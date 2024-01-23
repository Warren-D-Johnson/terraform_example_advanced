
variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name at Cloudflare"
  type        = string
}

variable "origin_cache_rule_name" {
  description = "Name of the rule"
  type        = string
}