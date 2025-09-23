output "raw_bucket_name" {
  description = "Name of the raw data S3 bucket"
  value       = aws_s3_bucket.raw_data.bucket
}

output "raw_bucket_arn" {
  description = "ARN of the raw data S3 bucket"
  value       = aws_s3_bucket.raw_data.arn
}

output "processed_bucket_name" {
  description = "Name of the processed data S3 bucket"
  value       = aws_s3_bucket.processed_data.bucket
}

output "processed_bucket_arn" {
  description = "ARN of the processed data S3 bucket"
  value       = aws_s3_bucket.processed_data.arn
}

output "models_bucket_name" {
  description = "Name of the models S3 bucket"
  value       = aws_s3_bucket.models.bucket
}

output "models_bucket_arn" {
  description = "ARN of the models S3 bucket"
  value       = aws_s3_bucket.models.arn
}

output "errors_bucket_name" {
  description = "Name of the errors S3 bucket"
  value       = aws_s3_bucket.errors.bucket
}

output "errors_bucket_arn" {
  description = "ARN of the errors S3 bucket"
  value       = aws_s3_bucket.errors.arn
}

output "kms_key_id" {
  description = "KMS key ID used for S3 encryption"
  value       = aws_kms_key.s3.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN used for S3 encryption"
  value       = aws_kms_key.s3.arn
}