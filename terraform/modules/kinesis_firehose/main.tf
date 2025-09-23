# IAM role for Kinesis Firehose
resource "aws_iam_role" "firehose_delivery" {
  name = "${var.project_name}-${var.environment}-firehose-delivery-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
  
  tags = var.tags
}

# IAM policy for Firehose to access S3
resource "aws_iam_policy" "firehose_s3" {
  name = "${var.project_name}-${var.environment}-firehose-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
  
  tags = var.tags
}

# IAM policy for Firehose to access Kinesis
resource "aws_iam_policy" "firehose_kinesis" {
  name = "${var.project_name}-${var.environment}-firehose-kinesis-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ]
        Resource = var.kinesis_stream_arn
      }
    ]
  })
  
  tags = var.tags
}

# IAM policy for Firehose to invoke Lambda
resource "aws_iam_policy" "firehose_lambda" {
  name = "${var.project_name}-${var.environment}-firehose-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ]
        Resource = var.transform_lambda_arn
      }
    ]
  })
  
  tags = var.tags
}

# IAM policy for CloudWatch logs
resource "aws_iam_policy" "firehose_logs" {
  name = "${var.project_name}-${var.environment}-firehose-logs-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/kinesisfirehose/*"
      }
    ]
  })
  
  tags = var.tags
}

# Attach policies to the Firehose role
resource "aws_iam_role_policy_attachment" "firehose_s3" {
  role       = aws_iam_role.firehose_delivery.name
  policy_arn = aws_iam_policy.firehose_s3.arn
}

resource "aws_iam_role_policy_attachment" "firehose_kinesis" {
  role       = aws_iam_role.firehose_delivery.name
  policy_arn = aws_iam_policy.firehose_kinesis.arn
}

resource "aws_iam_role_policy_attachment" "firehose_lambda" {
  role       = aws_iam_role.firehose_delivery.name
  policy_arn = aws_iam_policy.firehose_lambda.arn
}

resource "aws_iam_role_policy_attachment" "firehose_logs" {
  role       = aws_iam_role.firehose_delivery.name
  policy_arn = aws_iam_policy.firehose_logs.arn
}

# CloudWatch Log Group for Firehose
resource "aws_cloudwatch_log_group" "firehose" {
  name              = "/aws/kinesisfirehose/${var.project_name}-${var.environment}-to-s3"
  retention_in_days = 7
  
  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "firehose_delivery" {
  name           = "DestinationDelivery"
  log_group_name = aws_cloudwatch_log_group.firehose.name
}

resource "aws_cloudwatch_log_stream" "firehose_backup" {
  name           = "BackupDelivery"
  log_group_name = aws_cloudwatch_log_group.firehose.name
}

# Kinesis Data Firehose delivery stream
resource "aws_kinesis_firehose_delivery_stream" "browser_analytics" {
  name        = "${var.project_name}-${var.environment}-to-s3"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_stream_arn
    role_arn           = aws_iam_role.firehose_delivery.arn
  }

  extended_s3_configuration {
    role_arn        = aws_iam_role.firehose_delivery.arn
    bucket_arn      = var.s3_bucket_arn
    prefix          = "raw/user_shard=!{partitionKeyFromQuery:user_shard}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    error_output_prefix = "errors/"
    
    buffer_size        = 128
    buffer_interval    = 300
    compression_format = "GZIP"

    # Data format conversion to Parquet
    data_format_conversion_configuration {
      enabled = true
      
      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }
      
      schema_configuration {
        database_name = var.glue_database_name
        table_name    = var.glue_table_name
        role_arn      = aws_iam_role.firehose_delivery.arn
      }
    }

    # Data transformation with Lambda
    processing_configuration {
      enabled = true
      
      processors {
        type = "Lambda"
        
        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = var.transform_lambda_arn
        }
        
        parameters {
          parameter_name  = "BufferSizeInMBs"
          parameter_value = "3"
        }
        
        parameters {
          parameter_name  = "BufferIntervalInSeconds"
          parameter_value = "60"
        }
      }
    }

    # Error handling
    s3_backup_mode = "Enabled"
    
    s3_backup_configuration {
      role_arn           = aws_iam_role.firehose_delivery.arn
      bucket_arn         = var.s3_errors_bucket_arn
      prefix             = "firehose-backup/"
      buffer_size        = 10
      buffer_interval    = 400
      compression_format = "GZIP"
    }

    # CloudWatch logging
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose.name
      log_stream_name = aws_cloudwatch_log_stream.firehose_delivery.name
    }
  }
  
  tags = var.tags
}

# CloudWatch alarms for Firehose
resource "aws_cloudwatch_metric_alarm" "firehose_delivery_to_s3_records" {
  alarm_name          = "${var.project_name}-${var.environment}-firehose-delivery-records"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "DeliveryToS3.Records"
  namespace           = "AWS/KinesisFirehose"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors Firehose delivery to S3"

  dimensions = {
    DeliveryStreamName = aws_kinesis_firehose_delivery_stream.browser_analytics.name
  }
  
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "firehose_delivery_to_s3_success" {
  alarm_name          = "${var.project_name}-${var.environment}-firehose-delivery-success"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DeliveryToS3.Success"
  namespace           = "AWS/KinesisFirehose"
  period              = "300"
  statistic           = "Average"
  threshold           = "0.95"
  alarm_description   = "This metric monitors Firehose delivery success rate"

  dimensions = {
    DeliveryStreamName = aws_kinesis_firehose_delivery_stream.browser_analytics.name
  }
  
  tags = var.tags
}