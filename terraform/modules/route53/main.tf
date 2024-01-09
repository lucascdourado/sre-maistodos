// Resource for creating a new Route53 zone with the provided domain name
resource "aws_route53_zone" "this" {
  name = var.domain_name
}

// Resource for creating a new Route53 record in the above zone
// This record is of type "A" and has an alias to the provided DNS name
resource "aws_route53_record" "this" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.region
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "*.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.region
    evaluate_target_health = true
  }
}