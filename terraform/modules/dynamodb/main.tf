# DynamoDB table for real-time user features
resource "aws_dynamodb_table" "user_features" {
  name           = "${var.project_name}-${var.environment}-user-features"
  billing_mode   = "ON_DEMAND"
  hash_key       = "user_id"
  range_key      = "feature_type"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "feature_type"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  attribute {
    name = "last_updated"
    type = "N"
  }

  global_secondary_index {
    name            = "CategoryIndex"
    hash_key        = "category"
    range_key       = "last_updated"
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = var.tags
}

# DynamoDB table for domain categories
resource "aws_dynamodb_table" "domain_categories" {
  name           = "${var.project_name}-${var.environment}-domain-categories"
  billing_mode   = "ON_DEMAND"
  hash_key       = "domain"

  attribute {
    name = "domain"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  global_secondary_index {
    name            = "CategoryIndex"
    hash_key        = "category"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = var.tags
}

# DynamoDB table for user sessions
resource "aws_dynamodb_table" "user_sessions" {
  name           = "${var.project_name}-${var.environment}-user-sessions"
  billing_mode   = "ON_DEMAND"
  hash_key       = "user_id"
  range_key      = "session_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "session_id"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "N"
  }

  global_secondary_index {
    name            = "SessionTimeIndex"
    hash_key        = "user_id"
    range_key       = "created_at"
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = var.tags
}

# DynamoDB table for audience segments
resource "aws_dynamodb_table" "audience_segments" {
  name           = "${var.project_name}-${var.environment}-audience-segments"
  billing_mode   = "ON_DEMAND"
  hash_key       = "segment_id"

  attribute {
    name = "segment_id"
    type = "S"
  }

  attribute {
    name = "created_by"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "N"
  }

  global_secondary_index {
    name            = "CreatedByIndex"
    hash_key        = "created_by"
    range_key       = "created_at"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = var.tags
}

# CloudWatch alarms for DynamoDB
resource "aws_cloudwatch_metric_alarm" "user_features_throttles" {
  alarm_name          = "${var.project_name}-${var.environment}-dynamodb-user-features-throttles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "UserErrorRate"
  namespace           = "AWS/DynamoDB"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  alarm_description   = "This metric monitors DynamoDB throttles"

  dimensions = {
    TableName = aws_dynamodb_table.user_features.name
  }
  
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "user_features_consumed_capacity" {
  alarm_name          = "${var.project_name}-${var.environment}-dynamodb-user-features-capacity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ConsumedReadCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "80"
  alarm_description   = "This metric monitors DynamoDB consumed capacity"

  dimensions = {
    TableName = aws_dynamodb_table.user_features.name
  }
  
  tags = var.tags
}