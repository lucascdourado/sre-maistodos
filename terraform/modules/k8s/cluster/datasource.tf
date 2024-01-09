data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = var.cluster_name
}