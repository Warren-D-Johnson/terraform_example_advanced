variable "apigw_sub_domain" {
  description = "APIGW sub domain (i.e. webcache)"
  type        = string
}

variable "apigw_domain" {
  description = "API GW domain (i.e. example.net)"
  type        = string
}

variable "lambda_name" {
  description = "API GW domain (i.e. example.net)"
  type        = string
}

variable "acm_domain_name" {
  description = "Domain name for finding ACM certificate"
  type        = string
}

variable "production_domain" {
  description = "Domain name used before caching"
  type        = string
}

variable "production_domain_cert" {
  description = "Domain name used for cert"
  type        = string
}

