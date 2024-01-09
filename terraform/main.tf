# Module for creating the network infrastructure
module "network" {
  source               = "./modules/network"
  vpc_name             = "${var.team}-${var.environment}"
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
  region               = var.region
  availability_zones   = local.production_availability_zones
  tags                 = var.tags
  cluster_name         = "${var.team}-${var.environment}"
}

# Module for creating the Kubernetes cluster
module "cluster" {
  source = "./modules/k8s/cluster"

  cluster_name       = "${var.team}-${var.environment}"
  kubernetes_version = 1.28

  region            = var.region
  vpc_id            = module.network.vpc_id
  private_subnet_1a = module.network.private_subnets_id[0]
  private_subnet_1b = module.network.private_subnets_id[1]
  public_subnet_1a  = module.network.public_subnets_id[0]
  public_subnet_1b  = module.network.public_subnets_id[1]

  tags = var.tags
}

# Module for creating the Kubernetes worker nodes
module "node" {
  source = "./modules/k8s/node"

  cluster_name = module.cluster.cluster_name

  private_subnet_1a = module.network.private_subnets_id[0]
  private_subnet_1b = module.network.private_subnets_id[1]
  public_subnet_1a  = module.network.public_subnets_id[0]
  public_subnet_1b  = module.network.public_subnets_id[1]

  capacity_type = "SPOT"
  instance_type = "t3a.medium"
  # instance_type = "t2.micro"
  desired_size  = 3
  min_size      = 1
  max_size      = 10

  tags = var.tags
}

# Module for configuring Route53 DNS
module "route53" {
  source = "./modules/route53"

  domain_name = "maistodos.com"
  dns_name    = data.aws_lb.eks.dns_name
  region      = data.aws_lb_hosted_zone_id.eks.id

  depends_on = [module.node, module.cluster]
}

# Module for configuring the Metabase application on Kubernetes
resource "helm_release" "metabase" {
  name      = "metabase"
  chart     = "../helm/metabase"
  namespace = "maistodos"

  depends_on = [module.node, module.cluster]
}