provider "aws" {
  region = var.region
}

resource "aws_dynamodb_table" "main" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "route"

  attribute {
    name = "route"
    type = "S"
  }

  replica {
    region_name = "eu-central-1"
  }
  replica {
    region_name = "us-west-2"
  }
  replica {
    region_name = "ap-southeast-1"
  }
  replica {
    region_name = "sa-east-1"
  }
}
