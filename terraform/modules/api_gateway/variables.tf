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

variable "authorizer_lambda_arn" {
  description = "ARN of the authorizer Lambda function"
  type        = string
}

variable "authorizer_lambda_function_name" {
  description = "Name of the authorizer Lambda function"
  type        = string
}

variable "kinesis_producer_lambda_arn" {
  description = "ARN of the Kinesis producer Lambda function"
  type        = string
}

variable "kinesis_producer_lambda_function_name" {
  description = "Name of the Kinesis producer Lambda function"
  type        = string
}

variable "cleanup_lambda_arn" {
  description = "ARN of the cleanup Lambda function"
  type        = string
}

variable "cleanup_lambda_function_name" {
  description = "Name of the cleanup Lambda function"
  type        = string
}

variable "recommendations_lambda_arn" {
  description = "ARN of the recommendations Lambda function"
  type        = string
}

variable "recommendations_lambda_function_name" {
  description = "Name of the recommendations Lambda function"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}