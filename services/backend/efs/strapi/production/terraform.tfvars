environment = "production" # Change this to "beta" or "staging" as needed

environments = {
  production = {
    region            = "us-east-2"
    vpc_name_tag      = "High Availability"
    subnet_tags       = ["High Availability A", "High Availability B", "High Availability C"]
    creation_token    = "EFS Strapi Production"
    sg_efs_to_origin  = "EFS to Origin"
    efs_access_point  = "EFS Strapi Production"
  },
  beta = {
    region            = "us-east-2"
    vpc_name_tag      = "High Availability"
    subnet_tags       = ["High Availability A", "High Availability B", "High Availability C"]
    creation_token    = "EFS Strapi Beta"
    sg_efs_to_origin  = "EFS to Origin"
    efs_access_point  = "EFS Strapi Beta"
  },
  staging = {
    region            = "us-east-2"
    vpc_name_tag      = "High Availability"
    subnet_tags       = ["High Availability A", "High Availability B", "High Availability C"]
    creation_token    = "EFS Strapi Staging"
    sg_efs_to_origin  = "EFS to Origin"
    efs_access_point  = "EFS Strapi Staging"
  }

}
