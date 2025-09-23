variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "shard_count" {
  description = "Initial number of shards for the Kinesis stream"
  type        = number
  default     = 10
}

variable "min_shard_count" {
  description = "Minimum number of shards for auto scaling"
  type        = number
  default     = 1
}

variable "max_shard_count" {
  description = "Maximum number of shards for auto scaling"
  type        = number
  default     = 1000
}

variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream"
  type        = number
  default     = 24
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}