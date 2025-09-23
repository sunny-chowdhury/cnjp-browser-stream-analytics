output "stream_name" {
  description = "Kinesis stream name"
  value       = aws_kinesis_stream.browser_analytics_events.name
}

output "stream_arn" {
  description = "Kinesis stream ARN"
  value       = aws_kinesis_stream.browser_analytics_events.arn
}

output "stream_id" {
  description = "Kinesis stream ID"
  value       = aws_kinesis_stream.browser_analytics_events.id
}

output "kms_key_id" {
  description = "KMS key ID used for encryption"
  value       = aws_kms_key.kinesis.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN used for encryption"
  value       = aws_kms_key.kinesis.arn
}

output "sns_topic_arn" {
  description = "SNS topic ARN for alerts"
  value       = aws_sns_topic.alerts.arn
}