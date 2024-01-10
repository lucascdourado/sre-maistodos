resource "random_password" "master_password" {
  length      = var.db_password.length
  special     = var.db_password.special
  min_lower   = var.db_password.min_lower
  min_upper   = var.db_password.min_upper
  min_numeric = var.db_password.min_numeric
}

resource "aws_ssm_parameter" "master_password" {
  name   = "/aurora/${var.cluster_identifier}"
  type   = "SecureString"
  value  = random_password.master_password.result
  key_id = aws_kms_key.this.key_id

  tags = merge({
    Name = "${var.cluster_identifier}"
  }, var.tags)

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.cluster_identifier}-db-subnet-group"
  subnet_ids = var.db_subnet_group

  tags = merge({
    Name = "${var.cluster_identifier}-db-subnet-group"
  }, var.tags)
}

resource "aws_rds_cluster" "this" {
  cluster_identifier           = var.cluster_identifier
  engine                       = var.engine
  engine_version               = var.engine_version
  database_name                = var.database_name
  master_username              = var.master_username
  master_password              = random_password.master_password.result
  port                         = var.port
  db_subnet_group_name         = aws_db_subnet_group.this.name
  vpc_security_group_ids       = concat(var.vpc_security_group_ids, [aws_security_group.this.id])
  apply_immediately            = var.apply_immediately
  allow_major_version_upgrade  = var.allow_major_version_upgrade
  storage_encrypted            = var.storage_encrypted
  kms_key_id                   = aws_kms_key.this.arn
  final_snapshot_identifier    = "${var.cluster_identifier}-final"
  copy_tags_to_snapshot        = true
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  tags = merge({
    Name = "${var.cluster_identifier}-cluster"
  }, var.tags)
}

resource "aws_rds_cluster_endpoint" "this" {
  cluster_identifier          = aws_rds_cluster.this.id
  cluster_endpoint_identifier = "${var.cluster_identifier}-cluster-endpoint"
  custom_endpoint_type        = "ANY"

  tags = merge({
    Name = "${var.cluster_identifier}-cluster-endpoint"
  }, var.tags)
}

resource "aws_rds_cluster_instance" "reader" {
  count                                 = var.cluster_instances_reader
  identifier                            = "${var.cluster_identifier}-reader-${count.index}"
  cluster_identifier                    = aws_rds_cluster.this.id
  instance_class                        = var.instance_class
  engine                                = var.engine
  engine_version                        = var.engine_version
  db_subnet_group_name                  = aws_db_subnet_group.this.name
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = var.allow_minor_version_upgrade
  publicly_accessible                   = var.publicly_accessible_reader
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = aws_kms_key.this.key_id
  performance_insights_retention_period = var.performance_insights_retention_period


  tags = merge({
    Name = "${var.cluster_identifier}-reader-${count.index}"
  }, var.tags)
}

resource "aws_rds_cluster_instance" "writer" {
  count                                 = var.cluster_instances_writer
  identifier                            = "${var.cluster_identifier}-writer-${count.index}"
  cluster_identifier                    = aws_rds_cluster.this.id
  instance_class                        = var.instance_class
  engine                                = var.engine
  engine_version                        = var.engine_version
  db_subnet_group_name                  = aws_db_subnet_group.this.name
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = var.allow_minor_version_upgrade
  publicly_accessible                   = var.publicly_accessible_writer
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = aws_kms_key.this.key_id
  performance_insights_retention_period = var.performance_insights_retention_period

  tags = merge({
    Name = "${var.cluster_identifier}-writer-${count.index}"
  }, var.tags)
}

resource "aws_security_group" "this" {
  name        = "${var.cluster_identifier}-sg"
  description = "Security group for ${var.cluster_identifier}"
  vpc_id      = var.vpc_id

  ingress = [for _, ingress in var.ingress_rules : {
    description      = ingress["description"]
    from_port        = ingress["from_port"]
    to_port          = ingress["to_port"]
    protocol         = ingress["protocol"]
    cidr_blocks      = ingress["cidr_blocks"]
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = false
  }]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.cluster_identifier}-sg"
  }, var.tags)
}

resource "aws_kms_key" "this" {
  description = "KMS key for ${var.cluster_identifier}"

  tags = merge({
    Name = "${var.cluster_identifier}-kms-key"
  }, var.tags)
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.cluster_identifier}-kms-key"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_appautoscaling_target" "this" {
  max_capacity       = lookup(var.scale, "max_capacity", 3)
  min_capacity       = lookup(var.scale, "min_capacity", 1)
  resource_id        = "cluster:${aws_rds_cluster.this.id}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "this" {
  name               = "cpu-utilization"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }

    target_value       = lookup(var.scale, "target_value", 80)
    scale_in_cooldown  = lookup(var.scale, "in_cooldown", 300)
    scale_out_cooldown = lookup(var.scale, "out_cooldown", 300)
  }
}