variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "kinesis_stream_arn" {
  description = "ARN of the source Kinesis Data Stream"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the destination S3 bucket"
  type        = string
}

variable "s3_errors_bucket_arn" {
  description = "ARN of the S3 bucket for errors and backup"
  type        = string
}

variable "transform_lambda_arn" {
  description = "ARN of the Lambda function for data transformation"
  type        = string
}

variable "glue_database_name" {
  description = "Name of the AWS Glue database for schema"
  type        = string
  default     = "browser_analytics"
}

variable "glue_table_name" {
  description = "Name of the AWS Glue table for schema"
  type        = string
  default     = "raw_events"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}