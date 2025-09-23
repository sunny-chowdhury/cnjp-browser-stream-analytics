# Browser Analytics Platform - Terraform Infrastructure

This Terraform configuration deploys a complete browser analytics platform on AWS based on the functional and technical specifications provided.

## Architecture Overview

The infrastructure deploys:

1. **CloudFront Distribution** - Serves JS library for browser data collection
2. **API Gateway WebSocket** - Real-time data ingestion from browser extensions
3. **API Gateway REST** - Ad recommendation API with caching
4. **Kinesis Data Streams** - High-throughput event streaming with auto-scaling
5. **Lambda Functions** - Stream processing, authorization, and recommendations
6. **DynamoDB Tables** - Real-time feature storage with TTL
7. **S3 Data Lake** - Raw and processed data with intelligent tiering
8. **Kinesis Data Firehose** - Stream-to-S3 with Parquet conversion
9. **ElastiCache Redis** - Sub-100ms recommendation caching
10. **VPC** - Secure networking with endpoints and flow logs

## Key Features

- **Privacy-First**: Complete user data isolation with encryption
- **High Performance**: Sub-100ms API response times with Redis caching
- **Auto-Scaling**: Kinesis shards and Lambda concurrency scale automatically
- **Cost-Optimized**: S3 lifecycle policies and on-demand DynamoDB pricing
- **Monitoring**: CloudWatch alarms and structured logging throughout
- **Security**: VPC endpoints, encryption at rest/transit, IAM least privilege

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0 installed
- Lambda deployment packages (see Lambda Functions section)

## Deployment

1. **Initialize Terraform**
   ```bash
   cd terraform/
   terraform init
   ```

2. **Review and customize variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Plan the deployment**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

## Configuration Variables

### Required Variables

- `aws_region` - AWS region for deployment (default: us-east-1)
- `project_name` - Project name for resource naming (default: browser-analytics)
- `environment` - Environment name (dev/staging/prod)
- `availability_zones` - List of AZs for multi-AZ deployment

### Optional Variables

- `kinesis_shard_count` - Initial Kinesis shard count (default: 10)
- `kinesis_retention_period` - Kinesis retention hours (default: 24)
- `vpc_cidr` - VPC CIDR block (default: 10.0.0.0/16)

## Lambda Functions

Before deployment, you need to create deployment packages for the Lambda functions:

### Required Lambda Packages

Create empty ZIP files or implement the functions based on the technical spec:

```bash
# Create placeholder packages
touch authorizer.zip kinesis_producer.zip cleanup.zip
touch stream_processor.zip transform.zip recommendations.zip

# Or implement actual functions
cd lambda/
zip -r ../authorizer.zip authorizer/
zip -r ../kinesis_producer.zip kinesis_producer/
# ... etc
```

### Lambda Function Purposes

- **authorizer**: JWT token validation for WebSocket connections
- **kinesis_producer**: Receives WebSocket data and writes to Kinesis
- **cleanup**: Handles WebSocket disconnections
- **stream_processor**: Real-time feature extraction from Kinesis streams
- **transform**: Data transformation for Firehose (anonymization, formatting)
- **recommendations**: Generates ad recommendations using cached features

## Post-Deployment Steps

1. **Upload JS Library to CloudFront**
   ```bash
   aws s3 cp browser-analytics.js s3://$(terraform output -raw cloudfront_s3_bucket)/
   aws cloudfront create-invalidation --distribution-id $(terraform output -raw cloudfront_distribution_id) --paths "/*"
   ```

2. **Configure Domain Categories**
   ```bash
   # Upload domain categorization data to DynamoDB
   aws dynamodb batch-write-item --request-items file://domain-categories.json
   ```

3. **Test WebSocket Connection**
   ```bash
   # Use wscat or similar to test WebSocket API
   wscat -c $(terraform output -raw websocket_api_endpoint)
   ```

## Data Flow

```
Browser Extension → WebSocket API → Kinesis Streams → Lambda Processor
                                         ↓
S3 Data Lake ← Firehose ← Transform Lambda ← Real-time Features (DynamoDB)
     ↓                                              ↓
Analytics/Athena                           Recommendations API (+ Redis Cache)
```

## Security Considerations

- All data encrypted in transit and at rest
- VPC endpoints for private AWS service communication  
- IAM roles follow least privilege principle
- User data isolated by shard/partition
- No PII stored in analytics layer (hashed user IDs)

## Cost Optimization

- **S3 Lifecycle**: Automatic transition to IA/Glacier/Deep Archive
- **DynamoDB On-Demand**: Pay per request, no pre-provisioning
- **Lambda**: Pay per execution, reserved concurrency for cost control
- **Kinesis Auto-Scaling**: Scale shards based on utilization
- **ElastiCache**: Right-sized for caching needs

## Monitoring

Key metrics and alarms included:
- Kinesis iterator age and throughput
- Lambda error rates and duration
- DynamoDB throttling and capacity
- API Gateway latency and error rates
- ElastiCache CPU and memory utilization

## Compliance Features

- **Data Retention**: Configurable retention policies
- **Data Deletion**: User data can be deleted within 72 hours
- **Audit Logging**: All data access logged via CloudTrail
- **Encryption**: End-to-end encryption for GDPR compliance

## Scaling

The infrastructure supports:
- **10M+ concurrent users** via Kinesis auto-scaling
- **1B+ daily events** through partitioned processing
- **Sub-100ms API responses** with Redis caching
- **Petabyte-scale analytics** via S3 data lake

## Outputs

After deployment, Terraform provides:
- `cloudfront_distribution_domain` - CDN URL for JS library
- `websocket_api_endpoint` - WebSocket API for data collection  
- `rest_api_endpoint` - REST API for ad recommendations
- `kinesis_stream_name` - Stream name for direct SDK access
- Various bucket names and resource identifiers

## Troubleshooting

Common issues and solutions:

1. **Lambda deployment packages missing**: Create placeholder ZIP files
2. **VPC endpoints timing out**: Check security group rules
3. **Kinesis throttling**: Increase shard count or enable auto-scaling
4. **DynamoDB throttling**: Verify on-demand billing mode
5. **High costs**: Review S3 lifecycle policies and Lambda concurrency limits

## Clean Up

To destroy the infrastructure:
```bash
terraform destroy
```

Note: S3 buckets with data may need to be emptied manually before destruction.