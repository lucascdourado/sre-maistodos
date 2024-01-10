// IAM role for the EKS master
resource "aws_iam_role" "eks_master_role" {

  name = "${var.cluster_name}-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = merge({
    Name = "${var.cluster_name}-master-role"
  }, var.tags)

}

// Attaches AmazonEKSClusterPolicy to the EKS master role
resource "aws_iam_role_policy_attachment" "eks_cluster_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_master_role.name
}

// Attaches AmazonEKSServicePolicy to the EKS master role
resource "aws_iam_role_policy_attachment" "eks_cluster_service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_master_role.name
}

// Security group for the EKS cluster
resource "aws_security_group" "eks_sg" {
  name   = "${var.cluster_name}-eks-sg"
  vpc_id = var.vpc_id

  tags = merge({
    Name = "${var.cluster_name}-eks-sg"
  }, var.tags)
}

// Ingress rule for the EKS security group to allow inbound HTTPS traffic
resource "aws_security_group_rule" "eks_sg_ingress_rule" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"

  security_group_id = aws_security_group.eks_sg.id
  type              = "ingress"
}

// KMS key for encrypting secrets for EKS
resource "aws_kms_key" "kms_key_eks" {
  description = "KMS key for encrypting secrets for EKS"
  tags = merge({
    Name = "${var.cluster_name}-eks-kms-key"
  }, var.tags)
}

// Alias for the EKS KMS key
resource "aws_kms_alias" "kms_alias_eks" {
  name          = "alias/${var.cluster_name}-eks-kms-key"
  target_key_id = aws_kms_key.kms_key_eks.key_id
}

// EKS cluster configuration
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.kubernetes_version

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids = [
      var.private_subnet_1a,
      var.private_subnet_1b,
      var.public_subnet_1a,
      var.public_subnet_1b
    ]
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.kms_key_eks.arn
    }
  }

  tags = merge({
    Name = "EKS ${var.cluster_name}",
    "kubernetes.io/cluster/${var.cluster_name}" : "owned"
  }, var.tags)

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_cluster,
    aws_iam_role_policy_attachment.eks_cluster_service
  ]

}

// EKS kube-proxy add-on to allow pods to communicate with each other within a cluster
resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
  depends_on   = [aws_eks_cluster.eks_cluster]
}

// EKS vpc-cni add-on to enable networking between pods
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "vpc-cni"
  addon_version = "v1.16.0-eksbuild.1"
  depends_on    = [aws_eks_cluster.eks_cluster]
}

// EKS CoreDNS add-on to enable DNS resolution
resource "aws_eks_addon" "core_dns" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "coredns"
  addon_version = "v1.10.1-eksbuild.6"
  depends_on    = [aws_eks_cluster.eks_cluster]
}

// EKS eks-pod-identity-agent add-on to enable IAM roles for service accounts
resource "aws_eks_addon" "eks_pod_identity_agent" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "eks-pod-identity-agent"
  depends_on   = [aws_eks_cluster.eks_cluster]
}

// IAM OpenID Connect provider for EKS cluster to allow IAM roles for service accounts
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates.0.sha1_fingerprint]
}

// IAM role for the AWS Load Balancer Controller to allow it to make calls to AWS APIs on your behalf
module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${var.cluster_name}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = aws_iam_openid_connect_provider.oidc_provider.arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

// Updates the kubeconfig for the EKS cluster to enable kubectl commands
resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}"
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

// Changes the kubectl context to the EKS cluster to enable kubectl commands
resource "null_resource" "change_context" {
  provisioner "local-exec" {
    command = "kubectl config use-context ${aws_eks_cluster.eks_cluster.arn}"
  }

  depends_on = [
    null_resource.kubeconfig
  ]
}

// Kubernetes service account for the AWS Load Balancer Controller to allow it to make calls to AWS APIs on your behalf
resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }

  depends_on = [
    null_resource.change_context
  ]
}
// Helm release for the AWS Load Balancer Controller to deploy the controller using Helm
resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.region}.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}

// Helm release for the metrics-server to enable monitoring
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

  set {
    name  = "args"
    value = "{--kubelet-insecure-tls=true}"
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}

// Kubernetes namespace for the application to isolate the application from other resources
resource "kubernetes_namespace" "this" {
  metadata {
    name = "maistodos"
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}

// Helm release for the load balancer to deploy the load balancer using Helm
resource "helm_release" "loadbalancer" {
  name      = "loadbalancer"
  chart     = "../helm/aws"
  namespace = "maistodos"

  depends_on = [kubernetes_namespace.this]
}