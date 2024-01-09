output "aurora_cluster_name" {
  description = "The name of the RDS cluster"
  value       = aws_rds_cluster.this.id
}

output "aurora_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.this.endpoint
}

output "aurora_cluster_port" {
  description = "The cluster port"
  value       = aws_rds_cluster.this.port
}

output "aurora_cluster_instance_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster_instance.reader[*].id
}

output "aurora_cluster_instance_writer_endpoint" {
  description = "The cluster writer instance"
  value       = aws_rds_cluster_instance.writer[*].id
}

output "database_name" {
  description = "The name of the database"
  value       = aws_rds_cluster.this.database_name
}

output "database_username" {
  description = "The username for the database"
  value       = aws_rds_cluster.this.master_username
}