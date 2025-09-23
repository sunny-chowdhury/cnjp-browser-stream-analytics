output "authorizer_lambda_arn" {
  description = "ARN of the authorizer Lambda function"
  value       = aws_lambda_function.authorizer.arn
}

output "authorizer_lambda_function_name" {
  description = "Name of the authorizer Lambda function"
  value       = aws_lambda_function.authorizer.function_name
}

output "kinesis_producer_lambda_arn" {
  description = "ARN of the Kinesis producer Lambda function"
  value       = aws_lambda_function.kinesis_producer.arn
}

output "kinesis_producer_lambda_function_name" {
  description = "Name of the Kinesis producer Lambda function"
  value       = aws_lambda_function.kinesis_producer.function_name
}

output "cleanup_lambda_arn" {
  description = "ARN of the cleanup Lambda function"
  value       = aws_lambda_function.cleanup.arn
}

output "cleanup_lambda_function_name" {
  description = "Name of the cleanup Lambda function"
  value       = aws_lambda_function.cleanup.function_name
}

output "stream_processor_lambda_arn" {
  description = "ARN of the stream processor Lambda function"
  value       = aws_lambda_function.stream_processor.arn
}

output "stream_processor_lambda_function_name" {
  description = "Name of the stream processor Lambda function"
  value       = aws_lambda_function.stream_processor.function_name
}

output "transform_lambda_arn" {
  description = "ARN of the transform Lambda function"
  value       = aws_lambda_function.transform.arn
}

output "transform_lambda_function_name" {
  description = "Name of the transform Lambda function"
  value       = aws_lambda_function.transform.function_name
}

output "recommendations_lambda_arn" {
  description = "ARN of the recommendations Lambda function"
  value       = aws_lambda_function.recommendations.arn
}

output "recommendations_lambda_function_name" {
  description = "Name of the recommendations Lambda function"
  value       = aws_lambda_function.recommendations.function_name
}

output "lambda_execution_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_execution.arn
}

output "sns_topic_errors_arn" {
  description = "ARN of the SNS topic for Lambda errors"
  value       = aws_sns_topic.lambda_errors.arn
}