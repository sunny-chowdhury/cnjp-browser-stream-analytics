# KMS Key for Kinesis Stream Encryption
# We need this to encrypt all the sensitive browser data flowing through kinesis
resource "aws_kms_key" "kinesis" {
  description             = "KMS key for Kinesis Data Stream encryption"
  deletion_window_in_days = 7  # minimum wait time before key is actually deleted
  
  tags = var.tags
}

# alias makes it easier to reference the key in other places
resource "aws_kms_alias" "kinesis" {
  name          = "alias/${var.project_name}-${var.environment}-kinesis"
  target_key_id = aws_kms_key.kinesis.key_id
}

# Kinesis Data Stream - The Heart of Our Real-time Pipeline
# This stream handles millions of browser events per day from user extensions
resource "aws_kinesis_stream" "browser_analytics_events" {
  name                      = "${var.project_name}-${var.environment}-events"
  shard_count               = var.shard_count                         # start with this many shards
  retention_period          = var.retention_period                   # how long to keep data (hours)
  shard_level_metrics       = ["IncomingRecords", "OutgoingRecords"] # track throughput metrics
  enforce_consumer_deletion = false                                  # don't force deletion of consumers
  
  encryption_type = "KMS"              # encrypt everything with our kms key
  kms_key_id      = aws_kms_key.kinesis.arn
  
  stream_mode_details {
    stream_mode = "PROVISIONED"        # we want control over shard scaling
  }
  
  tags = var.tags
}

# Auto Scaling for Kinesis Stream
# This automatically adds/removes shards based on traffic to handle load spikes

# scaling target for reading data from the stream (lambda consumers)
resource "aws_appautoscaling_target" "kinesis_read" {
  max_capacity       = var.max_shard_count                               # don't go above this
  min_capacity       = var.min_shard_count                               # don't go below this
  resource_id        = "stream/${aws_kinesis_stream.browser_analytics_events.name}"
  scalable_dimension = "kinesis:shard:ReadCapacity"
  service_namespace  = "kinesis"
}

# scaling target for writing data to the stream (from api gateway)
resource "aws_appautoscaling_target" "kinesis_write" {
  max_capacity       = var.max_shard_count
  min_capacity       = var.min_shard_count
  resource_id        = "stream/${aws_kinesis_stream.browser_analytics_events.name}"
  scalable_dimension = "kinesis:shard:WriteCapacity"
  service_namespace  = "kinesis"
}

# Auto Scaling Policies
# these policies define when and how to scale the stream based on metrics

# policy to scale up read capacity when incoming record rate is high
resource "aws_appautoscaling_policy" "kinesis_read_scale_up" {
  name               = "${var.project_name}-${var.environment}-kinesis-read-scale-up"
  policy_type        = "TargetTrackingScaling"         # automatically adjust to hit target
  resource_id        = aws_appautoscaling_target.kinesis_read.resource_id
  scalable_dimension = aws_appautoscaling_target.kinesis_read.scalable_dimension
  service_namespace  = aws_appautoscaling_target.kinesis_read.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70.0                               # try to keep utilization at 70%
    
    predefined_metric_specification {
      predefined_metric_type = "KinesisStreamIncomingRecords"  # scale based on incoming records
    }
    
    scale_out_cooldown = 300  # wait 5 min before scaling out again
    scale_in_cooldown  = 900  # wait 15 min before scaling in (more conservative)
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