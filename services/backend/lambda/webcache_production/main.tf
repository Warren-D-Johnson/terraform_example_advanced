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

data "aws_caller_identity" "current" {}

data "aws_iam_policy" "ddb_cache_tables" {
  name = var.ddb_access_policy #"DDB_CACHE_TABLES"
}

data "archive_file" "lambda_zip" {
  type                    = "zip"
  source_content          = <<-EOT
    exports.handler = async (event) => {
      const response = {
          statusCode: 200,
          body: JSON.stringify('Hello, World!'),
      };
      return response;
    };
  EOT
  source_content_filename = "index.js"
  output_path             = "${path.module}/lambda_function_payload.zip"
}

#######################################################################################
# Lambda function - us-east-2 Ohio
#######################################################################################
resource "aws_iam_role" "lambda_role_us_east_2" {
  provider = aws.us_east_2
  name = join("", [var.lambda_role_name,"_us_east_2"])
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Create lambda function
resource "aws_lambda_function" "lambda_us_east_2" {
  provider          = aws.us_east_2
  function_name     = join("", [var.lambda_name,"_oh"])
  description       = join("", [var.function_description, " Ohio"])
  filename          = data.archive_file.lambda_zip.output_path
  source_code_hash  = filebase64sha256(data.archive_file.lambda_zip.output_path)
  handler           = var.handler
  runtime           = var.runtime
  role              = aws_iam_role.lambda_role_us_east_2.arn
  memory_size       = var.memory_size
  timeout           = var.timeout
  environment {
    variables = var.env_vars[var.environment]
  }
  lifecycle {
    ignore_changes = [source_code_hash] # never update source code after lambda is created
  }
}

# Create lambda function URL
resource "aws_lambda_function_url" "lambda_us_east_2_function_url" {
  provider           = aws.us_east_2
  function_name      = aws_lambda_function.lambda_us_east_2.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

# Attach the basic execution role to us-east-2
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_us_east_2" {
  provider   = aws.us_east_2
  role       = aws_iam_role.lambda_role_us_east_2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Set async retries
resource "aws_lambda_function_event_invoke_config" "event_invoke_config_us_east_2" {
  function_name          = join("", [var.lambda_name,"_oh"])
  provider               = aws.us_east_2
  maximum_retry_attempts = 0
  depends_on             = [aws_lambda_function.lambda_us_east_2]
}

# Attach DDB_CACHE_TABLES policy to us-east-2 Lambda role
resource "aws_iam_role_policy_attachment" "ddb_cache_tables_us_east_2" {
  provider   = aws.us_east_2
  role       = aws_iam_role.lambda_role_us_east_2.name
  policy_arn = data.aws_iam_policy.ddb_cache_tables.arn # or directly the ARN if you have it
}

# Set Cloudwatch log retention time
resource "aws_cloudwatch_log_group" "lambda_log_group_us_east_2" {
  provider = aws.us_east_2
  name              = "/aws/lambda/${join("", [var.lambda_name,"_oh"])}"
  retention_in_days = 90
}


#######################################################################################
# Lambda function eu-central-1 Frankfurt
#######################################################################################
resource "aws_iam_role" "lambda_role_eu_central_1" {
  provider = aws.eu_central_1
  name = join("", [var.lambda_role_name,"_eu_central_1"])
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_lambda_function" "lambda_eu_central_1" {
  provider          = aws.eu_central_1
  function_name     = join("", [var.lambda_name,"_fk"])
  description       = join("", [var.function_description, " Frankfurt"])
  filename          = data.archive_file.lambda_zip.output_path
  source_code_hash  = filebase64sha256(data.archive_file.lambda_zip.output_path)
  handler           = var.handler
  runtime           = var.runtime
  role              = aws_iam_role.lambda_role_eu_central_1.arn
  memory_size       = var.memory_size
  timeout           = var.timeout
  environment {
    variables = var.env_vars[var.environment]
  }
  lifecycle {
    ignore_changes = [source_code_hash] # never update source code after lambda is created
  }  
}

# Create lambda function URL
resource "aws_lambda_function_url" "lambda_eu_central_1_function_url" {
  provider           = aws.eu_central_1
  function_name      = aws_lambda_function.lambda_eu_central_1.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

# Attach the basic execution role to eu-central-1
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_eu_central_1" {
  provider   = aws.eu_central_1
  role       = aws_iam_role.lambda_role_eu_central_1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function_event_invoke_config" "event_invoke_config_eu_central_1" {
  function_name          = join("", [var.lambda_name,"_fk"])
  provider               = aws.eu_central_1
  maximum_retry_attempts = 0
  depends_on             = [aws_lambda_function.lambda_eu_central_1]
}

# Set Cloudwatch log retention time
resource "aws_cloudwatch_log_group" "lambda_log_group_eu_central_1" {
  provider = aws.eu_central_1
  name              = "/aws/lambda/${join("", [var.lambda_name,"_fk"])}"
  retention_in_days = 90
}

# Attach DDB_CACHE_TABLES policy to eu-central-1 Lambda role
resource "aws_iam_role_policy_attachment" "ddb_cache_tables_eu_central_1" {
  provider   = aws.eu_central_1
  role       = aws_iam_role.lambda_role_eu_central_1.name
  policy_arn = data.aws_iam_policy.ddb_cache_tables.arn # or directly the ARN if you have it
}


#######################################################################################
# Lambda function us-west-2 Oregon
#######################################################################################

resource "aws_iam_role" "lambda_role_us_west_2" {
  provider = aws.us_west_2
  name = join("", [var.lambda_role_name,"_us_west_2"])
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_lambda_function" "lambda_us_west_2" {
  provider          = aws.us_west_2
  function_name     = join("", [var.lambda_name,"_or"])
  description       = join("", [var.function_description, " Oregon"])
  filename          = data.archive_file.lambda_zip.output_path
  source_code_hash  = filebase64sha256(data.archive_file.lambda_zip.output_path)
  handler           = var.handler
  runtime           = var.runtime
  role              = aws_iam_role.lambda_role_us_west_2.arn
  memory_size       = var.memory_size
  timeout           = var.timeout
  environment {
    variables = var.env_vars[var.environment]
  }
  lifecycle {
    ignore_changes = [source_code_hash] # never update source code after lambda is created
  }
}

# Create lambda function URL
resource "aws_lambda_function_url" "lambda_us_west_2_function_url" {
  provider           = aws.us_west_2
  function_name      = aws_lambda_function.lambda_us_west_2.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_us_west_2" {
  provider   = aws.us_west_2
  role       = aws_iam_role.lambda_role_us_west_2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function_event_invoke_config" "event_invoke_config_us_west_2" {
  function_name          = join("", [var.lambda_name,"_or"])
  provider               = aws.us_west_2
  maximum_retry_attempts = 0
  depends_on             = [aws_lambda_function.lambda_us_west_2]
}

# Set Cloudwatch log retention time
resource "aws_cloudwatch_log_group" "lambda_log_group_us_west_2" {
  provider          = aws.us_west_2
  name              = "/aws/lambda/${join("", [var.lambda_name,"_or"])}"
  retention_in_days = 90
}

resource "aws_iam_role_policy_attachment" "ddb_cache_tables_us_west_2" {
  provider   = aws.us_west_2
  role       = aws_iam_role.lambda_role_us_west_2.name
  policy_arn = data.aws_iam_policy.ddb_cache_tables.arn # or directly the ARN if you have it
}


#######################################################################################
# Lambda function ap-southeast-1 Singapore
#######################################################################################

resource "aws_iam_role" "lambda_role_ap_southeast_1" {
  provider = aws.ap_southeast_1
  name = join("", [var.lambda_role_name,"_ap_southeast_1"])
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_lambda_function" "lambda_ap_southeast_1" {
  provider         = aws.ap_southeast_1
  function_name    = join("", [var.lambda_name,"_sg"])
  description      = join("", [var.function_description, " Singapore"])
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.lambda_role_ap_southeast_1.arn
  memory_size      = var.memory_size
  timeout          = var.timeout
  environment {
    variables = var.env_vars[var.environment]
  }
  lifecycle {
    ignore_changes = [source_code_hash] # never update source code after lambda is created
  }
}

# Create lambda function URL
resource "aws_lambda_function_url" "lambda_ap_southeast_1_function_url" {
  provider           = aws.ap_southeast_1
  function_name      = aws_lambda_function.lambda_ap_southeast_1.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_ap_southeast_1" {
  provider   = aws.ap_southeast_1
  role       = aws_iam_role.lambda_role_ap_southeast_1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function_event_invoke_config" "event_invoke_config_ap_southeast_1" {
  function_name          = join("", [var.lambda_name,"_sg"])
  provider               = aws.ap_southeast_1
  maximum_retry_attempts = 0
  depends_on             = [aws_lambda_function.lambda_ap_southeast_1]
}

resource "aws_cloudwatch_log_group" "lambda_log_group_ap_southeast_1" {
  provider          = aws.ap_southeast_1
  name              = "/aws/lambda/${join("", [var.lambda_name,"_sg"])}"
  retention_in_days = 90
}

resource "aws_iam_role_policy_attachment" "ddb_cache_tables_ap_southeast_1" {
  provider   = aws.ap_southeast_1
  role       = aws_iam_role.lambda_role_ap_southeast_1.name
  policy_arn = data.aws_iam_policy.ddb_cache_tables.arn # or directly the ARN if you have it
}


#######################################################################################
# Lambda function sa-east-1 Sao Paulo, Brazil
#######################################################################################

resource "aws_iam_role" "lambda_role_sa_east_1" {
  provider = aws.sa_east_1
  name = join("", [var.lambda_role_name,"_sa_east_1"])
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_lambda_function" "lambda_sa_east_1" {
  provider         = aws.sa_east_1
  function_name    = join("", [var.lambda_name,"_br"])
  description      = join("", [var.function_description, " Brazil"])
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.lambda_role_sa_east_1.arn
  memory_size      = var.memory_size
  timeout          = var.timeout
  environment {
    variables = var.env_vars[var.environment]
  }
  lifecycle {
    ignore_changes = [source_code_hash] # never update source code after lambda is created
  }
}

# Create lambda function URL
resource "aws_lambda_function_url" "lambda_sa_east_1_function_url" {
  provider           = aws.sa_east_1
  function_name      = aws_lambda_function.lambda_sa_east_1.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_sa_east_1" {
  provider   = aws.sa_east_1
  role       = aws_iam_role.lambda_role_sa_east_1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function_event_invoke_config" "event_invoke_config_sa_east_1" {
  function_name          = join("", [var.lambda_name,"_br"])
  provider               = aws.sa_east_1
  maximum_retry_attempts = 0
  depends_on             = [aws_lambda_function.lambda_sa_east_1]
}

resource "aws_cloudwatch_log_group" "lambda_log_group_sa_east_1" {
  provider          = aws.sa_east_1
  name              = "/aws/lambda/${join("", [var.lambda_name,"_br"])}"
  retention_in_days = 90
}

resource "aws_iam_role_policy_attachment" "ddb_cache_tables_sa_east_1" {
  provider   = aws.sa_east_1
  role       = aws_iam_role.lambda_role_sa_east_1.name
  policy_arn = data.aws_iam_policy.ddb_cache_tables.arn # or directly the ARN if you have it
}


