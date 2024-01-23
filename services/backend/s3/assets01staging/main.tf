provider "aws" {
  region = var.env_configs[var.environment].region
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.env_configs[var.environment].bucket_name
}

resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  bucket = aws_s3_bucket.bucket.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "bucket_website_configuration" {
  bucket = aws_s3_bucket.bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.bucket
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership_controls,
    aws_s3_bucket_public_access_block.bucket_public_access_block,
  ]
  
  acl    = "public-read"
}

# policy to make new files public by default
resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [ aws_s3_bucket.bucket ]
  bucket = aws_s3_bucket.bucket.bucket
  policy = jsonencode({
 
    Version   = "2008-10-17"
    Id        = "Policy1397632521960"
    Statement = [
      {
        Sid       = "Stmt1397633323327"
        Effect    = "Allow"
        Principal = { "AWS": "*" }
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.env_configs[var.environment].bucket_name}/*"
      }
    ]
  
  } )
}
