output "features_table_name" {
  description = "Name of the user features DynamoDB table"
  value       = aws_dynamodb_table.user_features.name
}

output "features_table_arn" {
  description = "ARN of the user features DynamoDB table"
  value       = aws_dynamodb_table.user_features.arn
}

output "domain_categories_table_name" {
  description = "Name of the domain categories DynamoDB table"
  value       = aws_dynamodb_table.domain_categories.name
}

output "domain_categories_table_arn" {
  description = "ARN of the domain categories DynamoDB table"
  value       = aws_dynamodb_table.domain_categories.arn
}

output "user_sessions_table_name" {
  description = "Name of the user sessions DynamoDB table"
  value       = aws_dynamodb_table.user_sessions.name
}

output "user_sessions_table_arn" {
  description = "ARN of the user sessions DynamoDB table"
  value       = aws_dynamodb_table.user_sessions.arn
}

output "audience_segments_table_name" {
  description = "Name of the audience segments DynamoDB table"
  value       = aws_dynamodb_table.audience_segments.name
}

output "audience_segments_table_arn" {
  description = "ARN of the audience segments DynamoDB table"
  value       = aws_dynamodb_table.audience_segments.arn
}