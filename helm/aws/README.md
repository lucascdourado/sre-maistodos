# ALB Helm Chart

## Overview

This Helm chart deploys an AWS Application Load Balancer (ALB) for Kubernetes, routing traffic to backend and frontend services.

## Installation

```bash
helm install my-alb-release ./alb-chart
```
# Terraform Deployment

To deploy the ALB Helm chart using Terraform, you can use the following steps:

## Prerequisites

Make sure you have the following prerequisites installed:

- Terraform
- kubectl
- Helm

## Terraform Configuration

Create a Terraform script (`main.tf`) with the following content:

```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" # Path to your kubeconfig file
  }
}

resource "helm_release" "alb" {
  name       = "my-alb-release"
  chart      = "./alb-chart"
  namespace  = "maistodos"
  values     = ["./alb-chart/values.yaml"]  # Path to your values file
}
```

### Deploy ALB with Terraform

Run the following commands to apply the Terraform configuration:

```bash
terraform init
terraform apply
```

## Verify Deployment

Ensure that the ALB and associated resources are deployed successfully:

```bash
kubectl get ingress -n maistodos
kubectl get services -n maistodos
```

## Clean Up

To remove the ALB deployment and associated resources, run:

```bash
terraform destroy
```

## Example Usage

For detailed configuration options, refer to the [Helm Chart](https://chat.openai.com/c/a4906ec1-bd10-48ba-a6b0-170e83c3d19a#) and [Terraform Provider for Helm documentation. Feel free to customize the values according to your specific requirements](https://github.com/hashicorp/terraform-provider-helm).

For more details, refer to the [official Helm documentation](https://helm.sh/docs/) and [Terraform documentation](https://www.terraform.io/docs/index.html).

