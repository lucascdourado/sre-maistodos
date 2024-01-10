# Metabase Helm Chart

## Overview

This Helm chart deploys Metabase, an open-source business intelligence tool, on Kubernetes. The chart includes configurations for deployment, service, horizontal pod autoscaling, and secrets.

## Installation

```bash
helm install my-metabase-release ./metabase
```
## Terraform Deployment

To deploy the Metabase Helm chart using Terraform, follow these steps:

### Prerequisites

Make sure you have the following prerequisites installed:

- Terraform
- kubectl
- Helm

### Terraform Configuration

Create a Terraform script (`main.tf`) with the following content:
```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" # Path to your kubeconfig file
}

resource "helm_release" "metabase" {
  name       = "my-metabase-release"
  chart      = "./metabase"
  namespace  = "maistodos"
  values     = ["./metabase/values.yaml"]  # Path to your values file
}
```
## Deploy Metabase with Terraform

Run the following commands to apply the Terraform configuration:

```bash
terraform init
terraform apply
```	
## Verify Deployment

Ensure that Metabase and associated resources are deployed successfully:

```bash
kubectl get pods -n maistodos
kubectl get services -n maistodos
kubectl get hpa -n maistodos
```
## Clean Up

To remove the Metabase deployment and associated resources, run:

```bash
terraform destroy
```
## Example Usage

For detailed configuration options, refer to the [Helm Chart documentation](https://helm.sh/docs/topics/charts/) and customize the `values.yaml` file according to your specific requirements.

For more details, refer to the [official Helm documentation](https://helm.sh/docs/) and [Terraform documentation](https://www.terraform.io/docs/index.html).
