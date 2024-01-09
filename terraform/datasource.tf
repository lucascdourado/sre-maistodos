data "aws_lb" "eks" {
  tags = {
    "elbv2.k8s.aws/cluster" = module.cluster.cluster_name,
    "ingress.k8s.aws/stack" = "${var.team}/${var.team}-ingress",
  }

  depends_on = [
    module.node
  ]
}

data "aws_lb_hosted_zone_id" "eks" {
  region = var.region
}