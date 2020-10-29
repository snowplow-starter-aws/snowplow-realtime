provider "aws" {
  alias   = "dns-provider"
  profile = var.dns_provider
  region  = var.dns_provider_region
}


resource "aws_acm_certificate" "cert" {
  domain_name       = "collector.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_route53_record" "validation-record" {
  provider = aws.dns-provider
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records = [
  each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = var.dns_zone_id
}


resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation-record : record.fqdn]
}


