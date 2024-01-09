output "zone_id" {
  description = "The ID of the created hosted zone"
  value       = aws_route53_zone.this.zone_id
}

output "record_name" {
  description = "The name of the created record"
  value       = aws_route53_record.this.name
}