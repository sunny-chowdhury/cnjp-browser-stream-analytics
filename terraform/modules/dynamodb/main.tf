# DynamoDB Table: User Real-time Features
# This is our hot storage for user behavioral data - gets hit on every ad request
resource "aws_dynamodb_table" "user_features" {
  name           = "${var.project_name}-${var.environment}-user-features"
  billing_mode   = "ON_DEMAND"     # pay per request - perfect for unpredictable load
  hash_key       = "user_id"       # partition key - ensures user data isolation
  range_key      = "feature_type"  # sort key - allows multiple feature types per user

  attribute {
    name = "user_id"
    type = "S"    # string
  }

  attribute {
    name = "feature_type"
    type = "S"    # string - values like "realtime_features", "categories_24h", etc
  }

  attribute {
    name = "category"
    type = "S"    # string - for gsi
  }

  attribute {
    name = "last_updated"
    type = "N"    # number - timestamp for gsi
  }

  # global secondary index for querying by category (used for segment creation)
  global_secondary_index {
    name            = "CategoryIndex"
    hash_key        = "category"      # partition by category
    range_key       = "last_updated"  # sort by time updated
    projection_type = "ALL"           # include all attributes in index
  }

  # automatically delete old feature data
  ttl {
    attribute_name = "ttl"     # ttl field name in records
    enabled        = true      # enables auto-deletion of expired records
  }

  # enables point-in-time recovery for compliance
  point_in_time_recovery {
    enabled = true
  }

  # encrypt sensitive user data
  server_side_encryption {
    enabled = true
  }

  tags = var.tags
}

# DynamoDB Table: Domain Categories Lookup
# Maps website domains to advertising categories (e.g., "amazon.com" -> "ecommerce")
resource "aws_dynamodb_table" "domain_categories" {
  name           = "${var.project_name}-${var.environment}-domain-categories"
  billing_mode   = "ON_DEMAND"
  hash_key       = "domain"        # partition key is the domain name

  attribute {
    name = "domain"
    type = "S"    # string - like "reddit.com", "amazon.com"
  }

  attribute {
    name = "category"
    type = "S"    # string - like "social", "ecommerce", "news"
  }

  # index to find all domains in a specific category
  global_secondary_index {
    name            = "CategoryIndex"
    hash_key        = "category"      # partition by category
    projection_type = "ALL"           # need all attributes for category queries
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