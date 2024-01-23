provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "useast2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "uswest2"
  region = "us-west-2"
}

provider "aws" {
  alias  = "eucentral1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "apsoutheast1"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "saeast1"
  region = "sa-east-1"
}

data "aws_route53_zone" "example_zone" {
  provider = aws.useast1
  name     = "${var.domain_name}."
}

data "aws_route53_zone" "example_zone_useast2" {
  provider = aws.useast2
  name     = "${var.domain_name}."
}

data "aws_route53_zone" "example_zone_uswest2" {
  provider = aws.uswest2
  name     = "${var.domain_name}."
}

data "aws_route53_zone" "example_zone_eucentral1" {
  provider = aws.eucentral1
  name     = "${var.domain_name}."
}

data "aws_route53_zone" "example_zone_apsoutheast1" {
  provider = aws.apsoutheast1
  name     = "${var.domain_name}."
}

data "aws_route53_zone" "example_zone_saeast1" {
  provider = aws.saeast1
  name     = "${var.domain_name}."
}

locals {
  validation_domains = toset([var.domain_name, "*.${var.domain_name}"])
}

# Certificate in us-east-1
resource "aws_acm_certificate" "example_cert_useast1" {
  provider                  = aws.useast1
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
}

resource "aws_route53_record" "example_validation_useast1" {
  provider = aws.useast1
  for_each = { for dvo in aws_acm_certificate.example_cert_useast1.domain_validation_options : dvo.domain_name => dvo }
  zone_id  = data.aws_route53_zone.example_zone.zone_id
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  records  = [each.value.resource_record_value]
  ttl      = 60
}

resource "aws_acm_certificate_validation" "example_cert_validation_useast1" {
  provider                = aws.useast1
  certificate_arn         = aws_acm_certificate.example_cert_useast1.arn
  validation_record_fqdns = [for record in aws_route53_record.example_validation_useast1 : record.fqdn]
}

# Certificate in us-east-2
resource "aws_acm_certificate" "example_cert_useast2" {
  provider                  = aws.useast2
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
}

resource "aws_route53_record" "example_validation_useast2" {
  provider = aws.useast2
  for_each = var.create_dns_record ? { 
    for dvo in aws_acm_certificate.example_cert_useast2.domain_validation_options : dvo.domain_name => dvo 
  } : {}
  zone_id  = data.aws_route53_zone.example_zone_useast2.zone_id
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  records  = [each.value.resource_record_value]
  ttl      = 60
}

resource "aws_acm_certificate_validation" "example_cert_validation_useast2" {
  provider                = aws.useast2
  certificate_arn         = aws_acm_certificate.example_cert_useast2.arn
  validation_record_fqdns = [for record in aws_route53_record.example_validation_useast2 : record.fqdn]
}


# Certificate in us-west-2
resource "aws_acm_certificate" "example_cert_uswest2" {
  provider                  = aws.uswest2
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
}

resource "aws_route53_record" "example_validation_uswest2" {
  for_each = var.create_dns_record ? { 
    for dvo in aws_acm_certificate.example_cert_uswest2.domain_validation_options : dvo.domain_name => dvo 
  } : {}
  provider = aws.uswest2
  zone_id  = data.aws_route53_zone.example_zone_uswest2.zone_id
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  records  = [each.value.resource_record_value]
  ttl      = 60
}

resource "aws_acm_certificate_validation" "example_cert_validation_uswest2" {
  provider                = aws.uswest2
  certificate_arn         = aws_acm_certificate.example_cert_uswest2.arn
  validation_record_fqdns = [for record in aws_route53_record.example_validation_uswest2 : record.fqdn]
}

# Certificate in eu-central-1
resource "aws_acm_certificate" "example_cert_eucentral1" {
  provider                  = aws.eucentral1
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
}

resource "aws_route53_record" "example_validation_eucentral1" {
  for_each = var.create_dns_record ? { 
    for dvo in aws_acm_certificate.example_cert_eucentral1.domain_validation_options : dvo.domain_name => dvo 
  } : {}
  provider = aws.eucentral1
  zone_id  = data.aws_route53_zone.example_zone_eucentral1.zone_id
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  records  = [each.value.resource_record_value]
  ttl      = 60
}

resource "aws_acm_certificate_validation" "example_cert_validation_eucentral1" {
  provider                = aws.eucentral1
  certificate_arn         = aws_acm_certificate.example_cert_eucentral1.arn
  validation_record_fqdns = [for record in aws_route53_record.example_validation_eucentral1 : record.fqdn]
}

# Certificate in ap-southeast-1 Singapore
resource "aws_acm_certificate" "example_cert_apsoutheast1" {
  provider                  = aws.apsoutheast1
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
}

resource "aws_route53_record" "example_validation_apsoutheast1" {
  for_each = var.create_dns_record ? { 
    for dvo in aws_acm_certificate.example_cert_apsoutheast1.domain_validation_options : dvo.domain_name => dvo 
  } : {}
  provider = aws.apsoutheast1
  zone_id  = data.aws_route53_zone.example_zone_apsoutheast1.zone_id
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  records  = [each.value.resource_record_value]
  ttl      = 60
}

resource "aws_acm_certificate_validation" "example_cert_validation_apsoutheast1" {
  provider                = aws.apsoutheast1
  certificate_arn         = aws_acm_certificate.example_cert_apsoutheast1.arn
  validation_record_fqdns = [for record in aws_route53_record.example_validation_apsoutheast1 : record.fqdn]
}


# Certificate in sa-east-1 Brazil
resource "aws_acm_certificate" "example_cert_saeast1" {
  provider                  = aws.saeast1
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
}

resource "aws_route53_record" "example_validation_saeast1" {
  for_each = var.create_dns_record ? { 
    for dvo in aws_acm_certificate.example_cert_saeast1.domain_validation_options : dvo.domain_name => dvo 
  } : {}
  provider = aws.saeast1
  zone_id  = data.aws_route53_zone.example_zone_saeast1.zone_id
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  records  = [each.value.resource_record_value]
  ttl      = 60
}

resource "aws_acm_certificate_validation" "example_cert_validation_saeast1" {
  provider                = aws.saeast1
  certificate_arn         = aws_acm_certificate.example_cert_saeast1.arn
  validation_record_fqdns = [for record in aws_route53_record.example_validation_saeast1 : record.fqdn]
}
