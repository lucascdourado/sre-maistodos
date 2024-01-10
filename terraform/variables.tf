variable "region" {
  description = "The region where the resources will be created"
  default     = "us-east-2"
}

variable "environment" {
  description = "The environment where the resources will be created"
  default     = "production"
}

variable "team" {
  description = "The team that will be responsible for the resources"
  default     = "maistodos"
}

variable "tags" {
  description = "The tags that will be added to the resources"
  default = {
    "Environment" = "production"
    "Team"        = "maistodos"
    "Terrafom"    = "true"
  }
}

variable "database_password" {
  description = "The password for the database"
  default     = null
}