variable "db_password" {
  description = "The password for the master DB user"
  default = {
    length      = 16
    special     = false
    min_lower   = 1
    min_upper   = 1
    min_numeric = 1
  }
}

variable "db_subnet_group" {
  description = "A list of DB subnet group to associate with this DB instance"
  type        = list(string)
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t4g.medium"
}

variable "cluster_identifier" {
  description = "The name of the RDS cluster"
  type        = string
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
  default     = "15.3"
}

variable "database_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the Cluster"
  type        = list(string)
  default     = []
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  type        = bool
  default     = false
}

variable "allow_minor_version_upgrade" {
  description = "Indicates that minor version upgrades are allowed"
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled"
  type        = string
  default     = "07:30-08:30"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range (in UTC) during which system maintenance can occur"
  type        = string
  default     = "mon:05:30-mon:06:30"
}

variable "cluster_instances_writer" {
  description = "The number of writer instances for the cluster"
  type        = number
  default     = 0
}

variable "publicly_accessible_writer" {
  description = "Determines if cluster can be publicly accessible"
  type        = bool
}

variable "cluster_instances_reader" {
  description = "The number of reader instances for the cluster"
  type        = number
  default     = 1
}

variable "publicly_accessible_reader" {
  description = "Determines if cluster can be publicly accessible"
  type        = bool
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "ingress_rules" {
  description = "A list of ingress rules to apply to the instance."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}


variable "scale" {
  description = "The autoscaling configuration"
  type = object({
    max_capacity = number
    min_capacity = number
    target_value = number
    in_cooldown  = number
    out_cooldown = number
  })
  default = {
    max_capacity = 3
    min_capacity = 1
    target_value = 80
    in_cooldown  = 300
    out_cooldown = 300
  }
}

