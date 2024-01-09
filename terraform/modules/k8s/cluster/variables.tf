variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version to use"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_1a" {
  description = "The ID of the private subnet 1a"
  type        = string
}

variable "private_subnet_1b" {
  description = "The ID of the private subnet 1b"
  type        = string
}

variable "public_subnet_1a" {
  description = "The ID of the public subnet 1a"
  type        = string
}

variable "public_subnet_1b" {
  description = "The ID of the public subnet 1b"
  type        = string
}

variable "region" {
  description = "The region to deploy the EKS cluster"
  type        = string
}

variable "tags" {
  description = "The tags to apply to the resources"
  type        = map(string)
}

variable "aws_profile" {
  default = "default"
}