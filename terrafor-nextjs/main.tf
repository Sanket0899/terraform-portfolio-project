provider "aws" {
    region = "ap-south-1"
}

resource "aws_s3_bucket" "tfproj" {
    bucket = "nextjs-san08-buck"

    tags = {
      Name = "nextjs-san08-buck"
    }
  
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.tfproj.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.tfproj.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.tfproj.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.tfproj.arn}/*"
      },
      {
      Sid       = "AllowBucketPolicyUpdate"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:PutBucketPolicy"
      Resource  = "${aws_s3_bucket.tfproj.arn}"
     }

    ]
  })
}

locals {
  s3_origin_id = "s3-website"
}


resource "aws_cloudfront_distribution" "s3_dist" {
  origin {
    domain_name = aws_s3_bucket.tfproj.bucket_regional_domain_name
    origin_id = local.s3_origin_id
  }

  enabled = true   #Whether the distribution is enabled to accept end user requests for content
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

  viewer_protocol_policy = "redirect-to-https"

  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  tags = {
    Environment = "project"
  }
}

