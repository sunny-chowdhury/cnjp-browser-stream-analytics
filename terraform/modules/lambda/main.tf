# IAM roles for Lambda functions
resource "aws_iam_role" "lambda_execution" {
  name = "${var.project_name}-${var.environment}-lambda-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  
  tags = var.tags
}

# IAM policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM policy for VPC access
resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# IAM policy for Kinesis access
resource "aws_iam_policy" "lambda_kinesis" {
  name = "${var.project_name}-${var.environment}-lambda-kinesis"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:DescribeStream",
          "kinesis:ListStreams",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Resource = var.kinesis_stream_arn
      }
    ]
  })
  
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_kinesis" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = aws_iam_policy.lambda_kinesis.arn
}

# IAM policy for DynamoDB access
resource "aws_iam_policy" "lambda_dynamodb" {
  name = "${var.project_name}-${var.environment}-lambda-dynamodb"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = var.dynamodb_table_arn
      }
    ]
  })
  
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = aws_iam_policy.lambda_dynamodb.arn
}

# IAM policy for S3 access
resource "aws_iam_policy" "lambda_s3" {
  name = "${var.project_name}-${var.environment}-lambda-s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.s3_bucket_arn
      }
    ]
  })
  
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = aws_iam_policy.lambda_s3.arn
}

# Lambda function for WebSocket authorization
resource "aws_lambda_function" "authorizer" {
  filename         = "authorizer.zip"
  function_name    = "${var.project_name}-${var.environment}-authorizer"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.11"
  timeout         = 30
  memory_size     = 256

  environment {
    variables = {
      JWT_SECRET = var.jwt_secret
      USER_TABLE = var.user_table_name
    }
  }

  tags = var.tags
}

# Lambda function for Kinesis producer (WebSocket data handler)
resource "aws_lambda_function" "kinesis_producer" {
  filename         = "kinesis_producer.zip"
  function_name    = "${var.project_name}-${var.environment}-kinesis-producer"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.11"
  timeout         = 10
  memory_size     = 512

  environment {
    variables = {
      KINESIS_STREAM_NAME = var.kinesis_stream_name
    }
  }

  tags = var.tags
}

# Lambda function for WebSocket cleanup
resource "aws_lambda_function" "cleanup" {
  filename         = "cleanup.zip"
  function_name    = "${var.project_name}-${var.environment}-cleanup"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.11"
  timeout         = 10
  memory_size     = 256

  tags = var.tags
}

# Lambda function for stream processing
resource "aws_lambda_function" "stream_processor" {
  filename         = "stream_processor.zip"
  function_name    = "${var.project_name}-${var.environment}-stream-processor"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.11"
  timeout         = 300
  memory_size     = 1024
  reserved_concurrent_executions = 1000

  environment {
    variables = {
      FEATURES_TABLE      = var.features_table_name
      DOMAIN_CATEGORIES_TABLE = var.domain_categories_table_name
      S3_BUCKET          = var.s3_bucket_name
      REDIS_ENDPOINT     = var.redis_endpoint
    }
  }

  tags = var.tags
}

# Event source mapping for Kinesis
resource "aws_lambda_event_source_mapping" "kinesis_processor" {
  event_source_arn                   = var.kinesis_stream_arn
  function_name                      = aws_lambda_function.stream_processor.arn
  starting_position                  = "LATEST"
  batch_size                        = 100
  maximum_batching_window_in_seconds = 5
  parallelization_factor            = 10
  maximum_record_age_in_seconds     = 3600
  bisect_batch_on_function_error    = true
  maximum_retry_attempts            = 3

  destination_config {
    on_failure {
      destination_arn = aws_sns_topic.lambda_errors.arn
    }
  }
}

# Lambda function for data transformation (Kinesis Firehose)
resource "aws_lambda_function" "transform" {
  filename         = "transform.zip"
  function_name    = "${var.project_name}-${var.environment}-transform"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.11"
  timeout         = 300
  memory_size     = 512

  tags = var.tags
}

# Lambda function for recommendations
resource "aws_lambda_function" "recommendations" {
  filename         = "recommendations.zip"
  function_name    = "${var.project_name}-${var.environment}-recommendations"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.11"
  timeout         = 30
  memory_size     = 1024

  environment {
    variables = {
      FEATURES_TABLE         = var.features_table_name
      REDIS_ENDPOINT        = var.redis_endpoint
      SAGEMAKER_ENDPOINT    = var.sagemaker_endpoint
    }
  }

  tags = var.tags
}

# SNS topic for Lambda errors
resource "aws_sns_topic" "lambda_errors" {
  name = "${var.project_name}-${var.environment}-lambda-errors"
  
  tags = var.tags
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "authorizer" {
  name              = "/aws/lambda/${aws_lambda_function.authorizer.function_name}"
  retention_in_days = 7
  
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "kinesis_producer" {
  name              = "/aws/lambda/${aws_lambda_function.kinesis_producer.function_name}"
  retention_in_days = 7
  
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "cleanup" {
  name              = "/aws/lambda/${aws_lambda_function.cleanup.function_name}"
  retention_in_days = 7
  
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "stream_processor" {
  name              = "/aws/lambda/${aws_lambda_function.stream_processor.function_name}"
  retention_in_days = 7
  
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "transform" {
  name              = "/aws/lambda/${aws_lambda_function.transform.function_name}"
  retention_in_days = 7
  
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "recommendations" {
  name              = "/aws/lambda/${aws_lambda_function.recommendations.function_name}"
  retention_in_days = 7
  
  tags = var.tags
}

# CloudWatch Alarms for Lambda functions
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.project_name}-${var.environment}-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors Lambda errors"
  alarm_actions       = [aws_sns_topic.lambda_errors.arn]

  dimensions = {
    FunctionName = aws_lambda_function.stream_processor.function_name
  }
  
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  alarm_name          = "${var.project_name}-${var.environment}-lambda-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Average"
  threshold           = "10000"
  alarm_description   = "This metric monitors Lambda duration"
  alarm_actions       = [aws_sns_topic.lambda_errors.arn]

  dimensions = {
    FunctionName = aws_lambda_function.stream_processor.function_name
  }
  
  tags = var.tags
}