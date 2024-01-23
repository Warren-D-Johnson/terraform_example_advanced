variable "environment" {
  description = "The target deployment environment"
  type        = string
}

variable "env_configs" {
  description = "Configuration for each environment"
  type = map(object({
    region      : string
    bucket_name : string
    acl         : string
  }))
}
