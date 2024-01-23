variable "domain_name" {
  description = "The domain name for which the ACM certificate will be created."
  type        = string
}

variable "create_dns_record" {
  description = "A boolean flag to indicate whether the DNS record should be created"
  type        = bool
  default     = true
}