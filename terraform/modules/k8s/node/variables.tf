variable "cluster_name" {
  description = "The name of the EKS cluster"
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

variable "desired_size" {
  description = "The desired number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
}

variable "tags" {
  description = "The tags to apply to the resources"
  type        = map(string)
}

variable "instance_type" {
  description = "The type of instance to use for the worker nodes"
  type        = string
}

variable "capacity_type" {
  description = "The capacity type of the worker nodes"
  type        = string
}