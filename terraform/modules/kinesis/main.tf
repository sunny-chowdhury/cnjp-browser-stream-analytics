# KMS key for Kinesis encryption
resource "aws_kms_key" "kinesis" {
  description             = "KMS key for Kinesis Data Stream encryption"
  deletion_window_in_days = 7
  
  tags = var.tags
}

resource "aws_kms_alias" "kinesis" {
  name          = "alias/${var.project_name}-${var.environment}-kinesis"
  target_key_id = aws_kms_key.kinesis.key_id
}

# Kinesis Data Stream
resource "aws_kinesis_stream" "browser_analytics_events" {
  name                      = "${var.project_name}-${var.environment}-events"
  shard_count               = var.shard_count
  retention_period          = var.retention_period
  shard_level_metrics       = ["IncomingRecords", "OutgoingRecords"]
  enforce_consumer_deletion = false
  
  encryption_type = "KMS"
  kms_key_id      = aws_kms_key.kinesis.arn
  
  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
  
  tags = var.tags
}

# Auto Scaling for Kinesis
resource "aws_appautoscaling_target" "kinesis_read" {
  max_capacity       = var.max_shard_count
  min_capacity       = var.min_shard_count
  resource_id        = "stream/${aws_kinesis_stream.browser_analytics_events.name}"
  scalable_dimension = "kinesis:shard:ReadCapacity"
  service_namespace  = "kinesis"
}

resource "aws_appautoscaling_target" "kinesis_write" {
  max_capacity       = var.max_shard_count
  min_capacity       = var.min_shard_count
  resource_id        = "stream/${aws_kinesis_stream.browser_analytics_events.name}"
  scalable_dimension = "kinesis:shard:WriteCapacity"
  service_namespace  = "kinesis"
}

# Auto Scaling Policies
resource "aws_appautoscaling_policy" "kinesis_read_scale_up" {
  name               = "${var.project_name}-${var.environment}-kinesis-read-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.kinesis_read.resource_id
  scalable_dimension = aws_appautoscaling_target.kinesis_read.scalable_dimension
  service_namespace  = aws_appautoscaling_target.kinesis_read.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70.0
    
    predefined_metric_specification {
      predefined_metric_type = "KinesisStreamIncomingRecords"
    }
    
    scale_out_cooldown = 300
    scale_in_cooldown  = 900
  }
}

resource "aws_appautoscaling_policy" "kinesis_write_scale_up" {
  name               = "${var.project_name}-${var.environment}-kinesis-write-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.kinesis_write.resource_id
  scalable_dimension = aws_appautoscaling_target.kinesis_write.scalable_dimension
  service_namespace  = aws_appautoscaling_target.kinesis_write.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70.0
    
    predefined_metric_specification {
      predefined_metric_type = "KinesisStreamOutgoingRecords"
    }
    
    scale_out_cooldown = 300
    scale_in_cooldown  = 900
  }
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "kinesis_iterator_age" {
  alarm_name          = "${var.project_name}-${var.environment}-kinesis-iterator-age"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "GetRecords.IteratorAgeMilliseconds"
  namespace           = "AWS/Kinesis"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "60000"
  alarm_description   = "This metric monitors Kinesis iterator age"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    StreamName = aws_kinesis_stream.browser_analytics_events.name
  }
  
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "kinesis_incoming_records" {
  alarm_name          = "${var.project_name}-${var.environment}-kinesis-incoming-records"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "IncomingRecords"
  namespace           = "AWS/Kinesis"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors Kinesis incoming records"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    StreamName = aws_kinesis_stream.browser_analytics_events.name
  }
  
  tags = var.tags
}

# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-${var.environment}-kinesis-alerts"
  
  tags = var.tags
}

# CloudWatch Log Group for Kinesis
resource "aws_cloudwatch_log_group" "kinesis" {
  name              = "/aws/kinesis/${aws_kinesis_stream.browser_analytics_events.name}"
  retention_in_days = 7
  
  tags = var.tags
}