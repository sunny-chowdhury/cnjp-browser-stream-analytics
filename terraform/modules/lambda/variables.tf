variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "kinesis_stream_arn" {
  description = "ARN of the Kinesis Data Stream"
  type        = string
}

variable "kinesis_stream_name" {
  description = "Name of the Kinesis Data Stream"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB features table"
  type        = string
}

variable "features_table_name" {
  description = "Name of the DynamoDB features table"
  type        = string
}

variable "domain_categories_table_name" {
  description = "Name of the DynamoDB domain categories table"
  type        = string
  default     = ""
}

variable "user_table_name" {
  description = "Name of the DynamoDB users table"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for processed data"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "redis_endpoint" {
  description = "ElastiCache Redis endpoint"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret for authorization"
  type        = string
  default     = "change-me-in-production"
  sensitive   = true
}

variable "sagemaker_endpoint" {
  description = "SageMaker endpoint name for ML inference"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}