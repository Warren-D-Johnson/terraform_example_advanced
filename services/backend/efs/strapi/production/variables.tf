variable "environment" {
  description = "Environment to deploy (production, beta, staging)"
  type        = string
}

variable "environments" {
  description = "Map of environments and their settings"
  type = map(object({
    region            = string
    vpc_name_tag      = string
    subnet_tags       = list(string)
    creation_token    = string
    sg_efs_to_origin  = string
    efs_access_point  = string
  }))
}
