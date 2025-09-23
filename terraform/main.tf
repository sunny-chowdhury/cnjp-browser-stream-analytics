terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# CloudFront Distribution for JS Library
module "cloudfront" {
  source = "./modules/cloudfront"
  
  project_name = var.project_name
  environment  = var.environment
  
  js_library_bucket_name = "${var.project_name}-${var.environment}-js-library"
  
  tags = var.tags
}

# API Gateway with WebSocket support
module "api_gateway" {
  source = "./modules/api_gateway"
  
  project_name = var.project_name
  environment  = var.environment
  
  kinesis_stream_arn = module.kinesis.stream_arn
  authorizer_lambda_arn = module.lambda.authorizer_lambda_arn
  authorizer_lambda_function_name = module.lambda.authorizer_lambda_function_name
  kinesis_producer_lambda_arn = module.lambda.kinesis_producer_lambda_arn
  kinesis_producer_lambda_function_name = module.lambda.kinesis_producer_lambda_function_name
  cleanup_lambda_arn = module.lambda.cleanup_lambda_arn
  cleanup_lambda_function_name = module.lambda.cleanup_lambda_function_name
  recommendations_lambda_arn = module.lambda.recommendations_lambda_arn
  recommendations_lambda_function_name = module.lambda.recommendations_lambda_function_name
  
  tags = var.tags
}

# Kinesis Data Streams
module "kinesis" {
  source = "./modules/kinesis"
  
  project_name = var.project_name
  environment  = var.environment
  
  shard_count = var.kinesis_shard_count
  retention_period = var.kinesis_retention_period
  
  tags = var.tags
}

# Lambda Functions
module "lambda" {
  source = "./modules/lambda"
  
  project_name = var.project_name
  environment  = var.environment
  
  kinesis_stream_arn = module.kinesis.stream_arn
  kinesis_stream_name = module.kinesis.stream_name
  dynamodb_table_arn = module.dynamodb.features_table_arn
  features_table_name = module.dynamodb.features_table_name
  domain_categories_table_name = module.dynamodb.domain_categories_table_name
  s3_bucket_name = module.s3.processed_bucket_name
  s3_bucket_arn = module.s3.processed_bucket_arn
  redis_endpoint = module.elasticache.redis_endpoint
  
  tags = var.tags
}

# DynamoDB Tables
module "dynamodb" {
  source = "./modules/dynamodb"
  
  project_name = var.project_name
  environment  = var.environment
  
  tags = var.tags
}

# S3 Data Lake
module "s3" {
  source = "./modules/s3"
  
  project_name = var.project_name
  environment  = var.environment
  
  tags = var.tags
}

# ElastiCache Redis
module "elasticache" {
  source = "./modules/elasticache"
  
  project_name = var.project_name
  environment  = var.environment
  
  vpc_id = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr_block
  subnet_ids = module.vpc.private_subnet_ids
  
  tags = var.tags
}

# VPC
module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  environment  = var.environment
  
  vpc_cidr = var.vpc_cidr
  availability_zones = var.availability_zones
  
  tags = var.tags
}

# Kinesis Data Firehose
module "kinesis_firehose" {
  source = "./modules/kinesis_firehose"
  
  project_name = var.project_name
  environment  = var.environment
  
  kinesis_stream_arn = module.kinesis.stream_arn
  s3_bucket_arn = module.s3.raw_bucket_arn
  s3_errors_bucket_arn = module.s3.errors_bucket_arn
  transform_lambda_arn = module.lambda.transform_lambda_arn
  
  tags = var.tags
}