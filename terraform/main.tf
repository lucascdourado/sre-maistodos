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

# Module for configuring the RDS database
module "aurora" {
  source = "./modules/rds"

  vpc_id                     = module.network.vpc_id
  cluster_identifier         = "metabase-${var.team}-${var.environment}"
  engine                     = "aurora-postgresql"
  engine_version             = "15.3"
  database_name              = "metabase"
  master_username            = "metabase"
  db_subnet_group            = [module.network.private_subnets_id[0], module.network.private_subnets_id[1]]
  cluster_instances_reader   = 1
  publicly_accessible_reader = true
  cluster_instances_writer   = 1
  publicly_accessible_writer = true

  db_password = {
    length      = 16
    special     = false
    min_lower   = 1
    min_upper   = 1
    min_numeric = 1
  }

  ingress_rules = [
    {
      description = "Public Subnets"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = module.network.public_subnets_cidr_block
    },
    {
      description = "Private Subnets"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = module.network.private_subnets_cidr_block
    },
  ]

  scale = {
    max_capacity = 3
    min_capacity = 1
    target_value = 80
    in_cooldown  = 300
    out_cooldown = 300
  }

  tags = var.tags

}


# Module for configuring the Metabase application on Kubernetes
resource "helm_release" "metabase" {
  name      = "metabase"
  chart     = "../helm/metabase"
  namespace = "maistodos"

  set {
    name  = "metabase.db.type"
    value = "postgres"
  }

  set {
    name  = "metabase.db.host"
    value = module.aurora.aurora_cluster_instance_writer_endpoint[0]
  }

  set {
    name  = "metabase.db.port"
    value = module.aurora.aurora_cluster_port
  }

  set {
    name  = "metabase.db.name"
    value = module.aurora.database_name
  }

  set {
    name  = "metabase.db.user"
    value = module.aurora.database_username
  }

  set {
    name  = "metabase.db.password"
    value = var.database_password
  }

  depends_on = [module.node, module.cluster, module.aurora]
}