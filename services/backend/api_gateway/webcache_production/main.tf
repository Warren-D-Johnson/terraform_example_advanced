# Ohio
provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}

# Frankfurt
provider "aws" {
  alias  = "eu_central_1"
  region = "eu-central-1"
}

# Oregon
provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
}

# Singapore
provider "aws" {
  alias  = "ap_southeast_1"
  region = "ap-southeast-1"
}

# Sao Paulo
provider "aws" {
  alias  = "sa_east_1"
  region = "sa-east-1"
}

locals {
  apigw_full_domain_oh = join("", [var.apigw_sub_domain, "-oh", ".", var.apigw_domain])
  apigw_full_domain_fk = join("", [var.apigw_sub_domain, "-fk", ".", var.apigw_domain])
  apigw_full_domain_or = join("", [var.apigw_sub_domain, "-or", ".", var.apigw_domain])
  apigw_full_domain_sg = join("", [var.apigw_sub_domain, "-sg", ".", var.apigw_domain])
  apigw_full_domain_br = join("", [var.apigw_sub_domain, "-br", ".", var.apigw_domain])
  apigw_full_domain    = join("", [var.apigw_sub_domain, ".", var.apigw_domain])
  production_name      = var.production_domain
  production_name_cert = var.production_domain_cert
}
  
###################################################################
# APIGW Ohio webcache-oh.example.net
###################################################################

resource "aws_apigatewayv2_api" "apigw_us_east_2" {
  
  provider      = aws.us_east_2
  name          = local.apigw_full_domain_oh
  description   = local.apigw_full_domain_oh
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

# Get lambda target function data 
data "aws_lambda_function" "apigw_us_east_2" {
  provider      = aws.us_east_2
  function_name = join("", [var.lambda_name,"_oh"])
}

data "aws_acm_certificate" "us_east_2" {
  provider    = aws.us_east_2
  domain      = var.acm_domain_name
  statuses    = ["ISSUED"]     # You can specify other statuses as needed
  most_recent = true        # Set to true if you want the most recently issued cert
}

data "aws_acm_certificate" "us_east_2_production_cert" {
  provider    = aws.us_east_2
  domain      = local.production_name_cert
  statuses    = ["ISSUED"]     # You can specify other statuses as needed
  most_recent = true        # Set to true if you want the most recently issued cert
}

resource "aws_apigatewayv2_integration" "apigw_us_east_2" {
  provider               = aws.us_east_2
  api_id                 = aws_apigatewayv2_api.apigw_us_east_2.id
  integration_type       = "AWS_PROXY"
  integration_uri        = data.aws_lambda_function.apigw_us_east_2.invoke_arn
  connection_type        = "INTERNET"
  payload_format_version = "2.0"  
}

resource "aws_apigatewayv2_route" "apigw_us_east_2" {
  provider   = aws.us_east_2
  api_id     = aws_apigatewayv2_api.apigw_us_east_2.id
  route_key  = "$default"
  target     = "integrations/${aws_apigatewayv2_integration.apigw_us_east_2.id}"
  depends_on = [aws_apigatewayv2_api.apigw_us_east_2, aws_apigatewayv2_integration.apigw_us_east_2]
}

resource "aws_apigatewayv2_stage" "apigw_us_east_2" {
  provider    = aws.us_east_2
  api_id      = aws_apigatewayv2_api.apigw_us_east_2.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "apigw_us_east_2" {
  provider    = aws.us_east_2
  domain_name = local.apigw_full_domain_oh
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.us_east_2.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_domain_name" "apigw_us_east_2_production_name" {
  provider    = aws.us_east_2
  domain_name = local.production_name
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.us_east_2_production_cert.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_domain_name" "apigw_us_east_2_full_domain" {
  provider    = aws.us_east_2
  domain_name = local.apigw_full_domain
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.us_east_2.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_api_mapping" "apigw_us_east_2" {
  provider    = aws.us_east_2
  api_id      = aws_apigatewayv2_api.apigw_us_east_2.id
  domain_name = local.apigw_full_domain_oh 
  stage       = aws_apigatewayv2_stage.apigw_us_east_2.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_us_east_2]
}

resource "aws_apigatewayv2_api_mapping" "apigw_us_east_2_full_domain" {
  provider    = aws.us_east_2
  api_id      = aws_apigatewayv2_api.apigw_us_east_2.id
  domain_name = local.apigw_full_domain
  stage       = aws_apigatewayv2_stage.apigw_us_east_2.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_us_east_2_full_domain]
}

resource "aws_apigatewayv2_api_mapping" "apigw_us_east_2_production_name" {
  provider    = aws.us_east_2
  api_id      = aws_apigatewayv2_api.apigw_us_east_2.id
  domain_name = local.production_name
  stage       = aws_apigatewayv2_stage.apigw_us_east_2.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_us_east_2_production_name]
}

resource "aws_lambda_permission" "allow_apigateway_us_east_2" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.apigw_us_east_2.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apigw_us_east_2.execution_arn}/*/*"
}


###################################################################
# APIGW Oregon webcache-or.example.net
###################################################################

resource "aws_apigatewayv2_api" "apigw_us_west_2" {
  
  provider      = aws.us_west_2
  name          = local.apigw_full_domain_or
  description   = local.apigw_full_domain_or
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

# Get lambda target function data 
data "aws_lambda_function" "apigw_us_west_2" {
  provider      = aws.us_west_2
  function_name = join("", [var.lambda_name,"_or"])
}

data "aws_acm_certificate" "us_west_2" {
  provider    = aws.us_west_2
  domain      = var.acm_domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "us_west_2_production_cert" {
  provider    = aws.us_west_2
  domain      = local.production_name_cert
  statuses    = ["ISSUED"]     # You can specify other statuses as needed
  most_recent = true        # Set to true if you want the most recently issued cert
}

resource "aws_apigatewayv2_integration" "apigw_us_west_2" {
  provider               = aws.us_west_2
  api_id                 = aws_apigatewayv2_api.apigw_us_west_2.id
  integration_type       = "AWS_PROXY"
  integration_uri        = data.aws_lambda_function.apigw_us_west_2.invoke_arn
  connection_type        = "INTERNET"
  payload_format_version = "2.0" 
}

resource "aws_apigatewayv2_route" "apigw_us_west_2" {
  provider   = aws.us_west_2
  api_id     = aws_apigatewayv2_api.apigw_us_west_2.id
  route_key  = "$default"
  target     = "integrations/${aws_apigatewayv2_integration.apigw_us_west_2.id}"
  depends_on = [aws_apigatewayv2_api.apigw_us_west_2, aws_apigatewayv2_integration.apigw_us_west_2]
}

resource "aws_apigatewayv2_stage" "apigw_us_west_2" {
  provider    = aws.us_west_2
  api_id      = aws_apigatewayv2_api.apigw_us_west_2.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "apigw_us_west_2" {
  provider    = aws.us_west_2
  domain_name = local.apigw_full_domain_or
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.us_west_2.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_domain_name" "apigw_us_west_2_production_name" {
  provider    = aws.us_west_2
  domain_name = local.production_name
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.us_west_2_production_cert.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}


resource "aws_apigatewayv2_domain_name" "apigw_us_west_2_full_domain" {
  provider    = aws.us_west_2
  domain_name = local.apigw_full_domain
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.us_west_2.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_api_mapping" "apigw_us_west_2" {
  provider    = aws.us_west_2
  api_id      = aws_apigatewayv2_api.apigw_us_west_2.id
  domain_name = local.apigw_full_domain_or 
  stage       = aws_apigatewayv2_stage.apigw_us_west_2.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_us_west_2]
}

resource "aws_apigatewayv2_api_mapping" "apigw_us_west_2_production_name" {
  provider    = aws.us_west_2
  api_id      = aws_apigatewayv2_api.apigw_us_west_2.id
  domain_name = local.production_name
  stage       = aws_apigatewayv2_stage.apigw_us_west_2.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_us_west_2_production_name]
}

resource "aws_apigatewayv2_api_mapping" "apigw_us_west_2_full_domain" {
  provider    = aws.us_west_2
  api_id      = aws_apigatewayv2_api.apigw_us_west_2.id
  domain_name = local.apigw_full_domain 
  stage       = aws_apigatewayv2_stage.apigw_us_west_2.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_us_west_2]
}

resource "aws_lambda_permission" "allow_apigateway_us_west_2" {
  provider      = aws.us_west_2
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.apigw_us_west_2.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apigw_us_west_2.execution_arn}/*/*"
}


###################################################################
# APIGW Frankfurt webcache-fk.example.net
###################################################################

resource "aws_apigatewayv2_api" "apigw_eu_central_1" {
  
  provider      = aws.eu_central_1
  name          = local.apigw_full_domain_fk
  description   = local.apigw_full_domain_fk
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

# Get lambda target function data 
data "aws_lambda_function" "apigw_eu_central_1" {
  provider      = aws.eu_central_1
  function_name = join("", [var.lambda_name,"_fk"])
}

data "aws_acm_certificate" "eu_central_1" {
  provider    = aws.eu_central_1
  domain      = var.acm_domain_name
  statuses    = ["ISSUED"]     # You can specify other statuses as needed
  most_recent = true        # Set to true if you want the most recently issued cert
}

data "aws_acm_certificate" "eu_central_1_production_cert" {
  provider    = aws.eu_central_1
  domain      = local.production_name_cert
  statuses    = ["ISSUED"]     # You can specify other statuses as needed
  most_recent = true        # Set to true if you want the most recently issued cert
}

resource "aws_apigatewayv2_integration" "apigw_eu_central_1" {
  provider               = aws.eu_central_1
  api_id                 = aws_apigatewayv2_api.apigw_eu_central_1.id
  integration_type       = "AWS_PROXY"
  integration_uri        = data.aws_lambda_function.apigw_eu_central_1.invoke_arn
  connection_type        = "INTERNET"
  payload_format_version = "2.0" 
}

resource "aws_apigatewayv2_route" "apigw_eu_central_1" {
  provider   = aws.eu_central_1
  api_id     = aws_apigatewayv2_api.apigw_eu_central_1.id
  route_key  = "$default"
  target     = "integrations/${aws_apigatewayv2_integration.apigw_eu_central_1.id}"
  depends_on = [aws_apigatewayv2_api.apigw_eu_central_1, aws_apigatewayv2_integration.apigw_eu_central_1]
}

resource "aws_apigatewayv2_stage" "apigw_eu_central_1" {
  provider    = aws.eu_central_1
  api_id      = aws_apigatewayv2_api.apigw_eu_central_1.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "apigw_eu_central_1" {
  provider    = aws.eu_central_1
  domain_name = local.apigw_full_domain_fk
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.eu_central_1.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_domain_name" "apigw_eu_central_1_production_name" {
  provider    = aws.eu_central_1
  domain_name = local.production_name
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.eu_central_1_production_cert.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_domain_name" "apigw_eu_central_1_full_domain" {
  provider    = aws.eu_central_1
  domain_name = local.apigw_full_domain
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.eu_central_1.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_api_mapping" "apigw_eu_central_1" {
  provider    = aws.eu_central_1
  api_id      = aws_apigatewayv2_api.apigw_eu_central_1.id
  domain_name = local.apigw_full_domain_fk 
  stage       = aws_apigatewayv2_stage.apigw_eu_central_1.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_eu_central_1]
}

resource "aws_apigatewayv2_api_mapping" "apigw_eu_central_1_production_name" {
  provider    = aws.eu_central_1
  api_id      = aws_apigatewayv2_api.apigw_eu_central_1.id
  domain_name = local.production_name
  stage       = aws_apigatewayv2_stage.apigw_eu_central_1.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_eu_central_1_production_name]
}


resource "aws_apigatewayv2_api_mapping" "apigw_eu_central_1_full_domain" {
  provider    = aws.eu_central_1
  api_id      = aws_apigatewayv2_api.apigw_eu_central_1.id
  domain_name = local.apigw_full_domain
  stage       = aws_apigatewayv2_stage.apigw_eu_central_1.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_eu_central_1_full_domain]
}

resource "aws_lambda_permission" "allow_apigateway_eu_central_1" {
  provider      = aws.eu_central_1
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.apigw_eu_central_1.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apigw_eu_central_1.execution_arn}/*/*"
}

###################################################################
# APIGW Singapore webcache-sg.example.net
###################################################################

resource "aws_apigatewayv2_api" "apigw_ap_southeast_1" {
  
  provider      = aws.ap_southeast_1
  name          = local.apigw_full_domain_sg
  description   = local.apigw_full_domain_sg
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

# Get lambda target function data 
data "aws_lambda_function" "apigw_ap_southeast_1" {
  provider      = aws.ap_southeast_1
  function_name = join("", [var.lambda_name,"_sg"])
}

data "aws_acm_certificate" "ap_southeast_1" {
  provider    = aws.ap_southeast_1
  domain      = var.acm_domain_name
  statuses    = ["ISSUED"]     # You can specify other statuses as needed
  most_recent = true        # Set to true if you want the most recently issued cert
}

data "aws_acm_certificate" "ap_southeast_1_production_cert" {
  provider    = aws.ap_southeast_1
  domain      = local.production_name_cert
  statuses    = ["ISSUED"]     # You can specify other statuses as needed
  most_recent = true        # Set to true if you want the most recently issued cert
}

resource "aws_apigatewayv2_integration" "apigw_ap_southeast_1" {
  provider               = aws.ap_southeast_1
  api_id                 = aws_apigatewayv2_api.apigw_ap_southeast_1.id
  integration_type       = "AWS_PROXY"
  integration_uri        = data.aws_lambda_function.apigw_ap_southeast_1.invoke_arn
  connection_type        = "INTERNET"
  payload_format_version = "2.0" 
}

resource "aws_apigatewayv2_route" "apigw_ap_southeast_1" {
  provider   = aws.ap_southeast_1
  api_id     = aws_apigatewayv2_api.apigw_ap_southeast_1.id
  route_key  = "$default"
  target     = "integrations/${aws_apigatewayv2_integration.apigw_ap_southeast_1.id}"
  depends_on = [aws_apigatewayv2_api.apigw_ap_southeast_1, aws_apigatewayv2_integration.apigw_ap_southeast_1]
}

resource "aws_apigatewayv2_stage" "apigw_ap_southeast_1" {
  provider    = aws.ap_southeast_1
  api_id      = aws_apigatewayv2_api.apigw_ap_southeast_1.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "apigw_ap_southeast_1" {
  provider    = aws.ap_southeast_1
  domain_name = local.apigw_full_domain_sg
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.ap_southeast_1.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_domain_name" "apigw_ap_southeast_1_production_name" {
  provider    = aws.ap_southeast_1
  domain_name = local.production_name
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.ap_southeast_1_production_cert.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_domain_name" "apigw_ap_southeast_1_full_domain" {
  provider    = aws.ap_southeast_1
  domain_name = local.apigw_full_domain
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.ap_southeast_1.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_api_mapping" "apigw_ap_southeast_1" {
  provider    = aws.ap_southeast_1
  api_id      = aws_apigatewayv2_api.apigw_ap_southeast_1.id
  domain_name = local.apigw_full_domain_sg 
  stage       = aws_apigatewayv2_stage.apigw_ap_southeast_1.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_ap_southeast_1]
}

resource "aws_apigatewayv2_api_mapping" "apigw_ap_southeast_1_production_name" {
  provider    = aws.ap_southeast_1
  api_id      = aws_apigatewayv2_api.apigw_ap_southeast_1.id
  domain_name = local.production_name
  stage       = aws_apigatewayv2_stage.apigw_ap_southeast_1.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_ap_southeast_1_production_name]
}

resource "aws_apigatewayv2_api_mapping" "apigw_ap_southeast_1_full_domain" {
  provider    = aws.ap_southeast_1
  api_id      = aws_apigatewayv2_api.apigw_ap_southeast_1.id
  domain_name = local.apigw_full_domain
  stage       = aws_apigatewayv2_stage.apigw_ap_southeast_1.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_ap_southeast_1_full_domain]
}

resource "aws_lambda_permission" "allow_apigateway_ap_southeast_1" {
  provider      = aws.ap_southeast_1
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.apigw_ap_southeast_1.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apigw_ap_southeast_1.execution_arn}/*/*"
}

###################################################################
# APIGW Brazil webcache-br.example.net
###################################################################

resource "aws_apigatewayv2_api" "apigw_sa_east_1" {
  
  provider      = aws.sa_east_1
  name          = local.apigw_full_domain_br
  description   = local.apigw_full_domain_br
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

# Get lambda target function data 
data "aws_lambda_function" "apigw_sa_east_1" {
  provider      = aws.sa_east_1
  function_name = join("", [var.lambda_name,"_br"])
}

data "aws_acm_certificate" "sa_east_1" {
  provider    = aws.sa_east_1
  domain      = var.acm_domain_name
  statuses    = ["ISSUED"]     # You can specify other statuses as needed
  most_recent = true        # Set to true if you want the most recently issued cert
}

data "aws_acm_certificate" "sa_east_1_production_cert" {
  provider    = aws.sa_east_1
  domain      = local.production_name_cert
  statuses    = ["ISSUED"]     # You can specify other statuses as needed
  most_recent = true        # Set to true if you want the most recently issued cert
}

resource "aws_apigatewayv2_integration" "apigw_sa_east_1" {
  provider               = aws.sa_east_1
  api_id                 = aws_apigatewayv2_api.apigw_sa_east_1.id
  integration_type       = "AWS_PROXY"
  integration_uri        = data.aws_lambda_function.apigw_sa_east_1.invoke_arn
  connection_type        = "INTERNET"
  payload_format_version = "2.0" 
}

resource "aws_apigatewayv2_route" "apigw_sa_east_1" {
  provider   = aws.sa_east_1
  api_id     = aws_apigatewayv2_api.apigw_sa_east_1.id
  route_key  = "$default"
  target     = "integrations/${aws_apigatewayv2_integration.apigw_sa_east_1.id}"
  depends_on = [aws_apigatewayv2_api.apigw_sa_east_1, aws_apigatewayv2_integration.apigw_sa_east_1]
}

resource "aws_apigatewayv2_stage" "apigw_sa_east_1" {
  provider    = aws.sa_east_1
  api_id      = aws_apigatewayv2_api.apigw_sa_east_1.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "apigw_sa_east_1" {
  provider    = aws.sa_east_1
  domain_name = local.apigw_full_domain_br
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.sa_east_1.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_domain_name" "apigw_sa_east_1_production_name" {
  provider    = aws.sa_east_1
  domain_name = local.production_name
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.sa_east_1_production_cert.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_domain_name" "apigw_sa_east_1_full_domain" {
  provider    = aws.sa_east_1
  domain_name = local.apigw_full_domain
  
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.sa_east_1.arn
    endpoint_type   = "REGIONAL" 
    security_policy = "TLS_1_2"  
  }
}

resource "aws_apigatewayv2_api_mapping" "apigw_sa_east_1" {
  provider    = aws.sa_east_1
  api_id      = aws_apigatewayv2_api.apigw_sa_east_1.id
  domain_name = local.apigw_full_domain_br 
  stage       = aws_apigatewayv2_stage.apigw_sa_east_1.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_sa_east_1]
}

resource "aws_apigatewayv2_api_mapping" "apigw_sa_east_1_production_name" {
  provider    = aws.sa_east_1
  api_id      = aws_apigatewayv2_api.apigw_sa_east_1.id
  domain_name = local.production_name
  stage       = aws_apigatewayv2_stage.apigw_sa_east_1.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_sa_east_1_production_name]
}

resource "aws_apigatewayv2_api_mapping" "apigw_sa_east_1_full_domain" {
  provider    = aws.sa_east_1
  api_id      = aws_apigatewayv2_api.apigw_sa_east_1.id
  domain_name = local.apigw_full_domain
  stage       = aws_apigatewayv2_stage.apigw_sa_east_1.id
  depends_on  = [aws_apigatewayv2_domain_name.apigw_sa_east_1_full_domain]
}

resource "aws_lambda_permission" "allow_apigateway_sa_east_1" {
  provider      = aws.sa_east_1
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.apigw_sa_east_1.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apigw_sa_east_1.execution_arn}/*/*"
}

