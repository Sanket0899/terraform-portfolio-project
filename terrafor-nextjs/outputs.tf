output "bucket_name" {
  value = aws_s3_bucket.tfproj.website_endpoint
  description = "The website endpoint of the S3 bucket"
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_dist.domain_name
  description = "The domain name of the CloudFront distribution"
}
