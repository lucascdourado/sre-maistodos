variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  type        = string
}

variable "public_subnets_cidr" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
}

variable "environment" {
  description = "The environment"
  type        = string
}

variable "region" {
  description = "The region to launch the bastion host"
  type        = string
}

variable "availability_zones" {
  description = "The az that the resources will be launched"
  type        = list(string)
}

variable "tags" {
  description = "The tags to apply to the resources"
  type        = map(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}