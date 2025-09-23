output "cloudfront_distribution_domain" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.distribution_domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}

output "websocket_api_endpoint" {
  description = "WebSocket API Gateway endpoint"
  value       = module.api_gateway.websocket_api_endpoint
}

output "rest_api_endpoint" {
  description = "REST API Gateway endpoint for recommendations"
  value       = module.api_gateway.rest_api_endpoint
}

output "kinesis_stream_name" {
  description = "Kinesis Data Stream name"
  value       = module.kinesis.stream_name
}

output "kinesis_stream_arn" {
  description = "Kinesis Data Stream ARN"
  value       = module.kinesis.stream_arn
}

output "s3_raw_bucket_name" {
  description = "S3 raw data bucket name"
  value       = module.s3.raw_bucket_name
}

output "s3_processed_bucket_name" {
  description = "S3 processed data bucket name"
  value       = module.s3.processed_bucket_name
}

output "dynamodb_features_table_name" {
  description = "DynamoDB features table name"
  value       = module.dynamodb.features_table_name
}

output "redis_endpoint" {
  description = "ElastiCache Redis endpoint"
  value       = module.elasticache.redis_endpoint
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}