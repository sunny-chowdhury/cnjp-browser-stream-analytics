# IAM Role for Lambda Functions
# All our lambda functions use this single role to keep things simple and consistent
resource "aws_iam_role" "lambda_execution" {
  name = "${var.project_name}-${var.environment}-lambda-execution"

  # this policy allows lambda service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"  # only lambda service can use this role
        }
      }
    ]
  })
  
  tags = var.tags
}

# attach aws managed policy for basic lambda execution (cloudwatch logs)
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"  # managed policy
}

# attach aws managed policy for vpc access (needed for accessing elasticache, etc)
resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"  # managed policy
}

# custom iam policy for kinesis access
# lambda functions need to read from and write to our kinesis stream
resource "aws_iam_policy" "lambda_kinesis" {
  name = "${var.project_name}-${var.environment}-lambda-kinesis"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:GetRecords",         # read data from stream
          "kinesis:GetShardIterator",   # get position in stream
          "kinesis:DescribeStream",     # get stream metadata
          "kinesis:ListStreams",        # list available streams
          "kinesis:PutRecord",          # write single record
          "kinesis:PutRecords"          # write multiple records (batch)
        ]
        Resource = var.kinesis_stream_arn  # only our specific stream
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

# Lambda Function: WebSocket Connection Authorizer
# This validates JWT tokens when users connect to our websocket api
resource "aws_lambda_function" "authorizer" {
  filename         = "authorizer.zip"                                      # deployment package
  function_name    = "${var.project_name}-${var.environment}-authorizer"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "index.lambda_handler"                                 # python function entry point
  runtime         = "python3.11"                                          # latest stable python
  timeout         = 30                                                     # max 30 seconds for auth
  memory_size     = 256                                                    # 256mb should be plenty for auth

  environment {
    variables = {
      JWT_SECRET = var.jwt_secret      # secret key for validating jwt tokens
      USER_TABLE = var.user_table_name # dynamodb table to check user status
    }
  }

  tags = var.tags
}

# Lambda Function: Kinesis Producer
# Takes websocket messages from browsers and pushes them into kinesis stream
resource "aws_lambda_function" "kinesis_producer" {
  filename         = "kinesis_producer.zip"
  function_name    = "${var.project_name}-${var.environment}-kinesis-producer"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.11"
  timeout         = 10                            # keep this fast since it's on the critical path
  memory_size     = 512                           # bit more memory for kinesis sdk operations

  environment {
    variables = {
      KINESIS_STREAM_NAME = var.kinesis_stream_name  # which stream to write to
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

# Lambda Function: Stream Processor (The Main Event Processing Engine)
# This is where the magic happens - processes kinesis events and extracts features for real-time targeting
resource "aws_lambda_function" "stream_processor" {
  filename         = "stream_processor.zip"
  function_name    = "${var.project_name}-${var.environment}-stream-processor"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.11"
  timeout         = 300                                        # 5 minutes max processing time
  memory_size     = 1024                                       # more memory for complex processing
  reserved_concurrent_executions = 1000                       # limit concurrent executions for cost control

  environment {
    variables = {
      FEATURES_TABLE           = var.features_table_name       # where to store user features
      DOMAIN_CATEGORIES_TABLE  = var.domain_categories_table_name  # lookup table for domain classification
      S3_BUCKET               = var.s3_bucket_name             # for processed data output
      REDIS_ENDPOINT          = var.redis_endpoint             # for caching recommendations
    }
  }

  tags = var.tags
}

# Event Source Mapping: Connects Kinesis Stream to Lambda Processor
# This tells aws to automatically invoke our lambda when new records arrive in kinesis
resource "aws_lambda_event_source_mapping" "kinesis_processor" {
  event_source_arn                   = var.kinesis_stream_arn              # our kinesis stream
  function_name                      = aws_lambda_function.stream_processor.arn
  starting_position                  = "LATEST"                            # only process new records, not historical
  batch_size                        = 100                                  # process up to 100 records at once
  maximum_batching_window_in_seconds = 5                                   # wait max 5 seconds to form batches
  parallelization_factor            = 10                                   # process up to 10 batches per shard in parallel
  maximum_record_age_in_seconds     = 3600                                # discard records older than 1 hour
  bisect_batch_on_function_error    = true                                # split failed batches to isolate bad records
  maximum_retry_attempts            = 3                                    # retry failed batches up to 3 times

  destination_config {
    on_failure {
      destination_arn = aws_sns_topic.lambda_errors.arn  # send failed records to sns for investigation
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