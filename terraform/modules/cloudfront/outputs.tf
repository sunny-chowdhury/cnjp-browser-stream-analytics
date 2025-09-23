output "distribution_id" {
  description = "CloudFront Distribution ID"
  value       = aws_cloudfront_distribution.js_library.id
}

output "distribution_domain_name" {
  description = "CloudFront Distribution domain name"
  value       = aws_cloudfront_distribution.js_library.domain_name
}

output "distribution_arn" {
  description = "CloudFront Distribution ARN"
  value       = aws_cloudfront_distribution.js_library.arn
}

output "s3_bucket_name" {
  description = "S3 bucket name for JS library"
  value       = aws_s3_bucket.js_library.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN for JS library"
  value       = aws_s3_bucket.js_library.arn
}