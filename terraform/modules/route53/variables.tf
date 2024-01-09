variable "domain_name" {
  description = "The domain name to redirect to the ALB"
  type        = string
}

variable "dns_name" {
  description = "The DNS name of the ALB"
  type        = string
}

variable "region" {
  description = "The zone ID of the ALB"
  type        = string
}