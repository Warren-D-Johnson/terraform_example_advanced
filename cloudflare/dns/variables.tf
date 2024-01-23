
variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name at Cloudflare"
  type        = string
}

variable "apex_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "apex_cname_value" {
  description = "CNAME value"
  type        = string
}

variable "api_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "api_cname_value" {
  description = "CNAME value"
  type        = string
}

# Production
variable "www_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "www_cname_value" {
  description = "CNAME value"
  type        = string
}

variable "cms_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "cms_cname_value" {
  description = "CNAME value"
  type        = string
}

variable "assets01_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "assets01_cname_value" {
  description = "CNAME value"
  type        = string
}

# Beta
variable "wwwbeta_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "wwwbeta_cname_value" {
  description = "CNAME value"
  type        = string
}

variable "cmsbeta_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "cmsbeta_cname_value" {
  description = "CNAME value"
  type        = string
}

variable "assets01beta_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "assets01beta_cname_value" {
  description = "CNAME value"
  type        = string
}

# Staging
variable "wwwstaging_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "wwwstaging_cname_value" {
  description = "CNAME value"
  type        = string
}

variable "cmsstaging_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "cmsstaging_cname_value" {
  description = "CNAME value"
  type        = string
}

variable "assets01staging_cname_name" {
  description = "CNAME name"
  type        = string
}

variable "assets01staging_cname_value" {
  description = "CNAME value"
  type        = string
}