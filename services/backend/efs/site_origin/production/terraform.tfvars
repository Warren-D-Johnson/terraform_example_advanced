environment = "production" # Change this to "beta" or "staging" as needed

environments = {
  production = {
    region            = "us-east-2"
    vpc_name_tag      = "High Availability"
    subnet_tags       = ["High Availability A", "High Availability B", "High Availability C"]
    creation_token    = "EFS NextJS Production"
    sg_efs_to_origin  = "EFS to Origin"
    efs_access_point  = "EFS NextJS Production"
  }
}
