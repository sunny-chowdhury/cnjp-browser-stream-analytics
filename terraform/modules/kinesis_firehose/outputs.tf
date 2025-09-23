output "delivery_stream_name" {
  description = "Name of the Kinesis Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.browser_analytics.name
}

output "delivery_stream_arn" {
  description = "ARN of the Kinesis Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.browser_analytics.arn
}

output "firehose_role_arn" {
  description = "ARN of the Firehose delivery role"
  value       = aws_iam_role.firehose_delivery.arn
}