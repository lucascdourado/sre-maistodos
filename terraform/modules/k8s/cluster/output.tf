output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_certificate_authority_data" {
  description = "The certificate-authority-data for the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority.0.data
}

output "cluster_token" {
  description = "The token of the EKS cluster"
  value       = data.aws_eks_cluster_auth.eks_cluster.token
}

