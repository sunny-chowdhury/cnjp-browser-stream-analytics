# S3 bucket for JS library
resource "aws_s3_bucket" "js_library" {
  bucket = var.js_library_bucket_name
  
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "js_library" {
  bucket = aws_s3_bucket.js_library.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "js_library" {
  bucket = aws_s3_bucket.js_library.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "js_library" {
  bucket = aws_s3_bucket.js_library.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "js_library" {
  name                              = "${var.project_name}-${var.environment}-js-library-oac"
  description                       = "OAC for JS library S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "js_library" {
  origin {
    domain_name              = aws_s3_bucket.js_library.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.js_library.id
    origin_id                = "S3-${aws_s3_bucket.js_library.bucket}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Browser Analytics JS Library Distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.js_library.bucket}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  # Cache behavior for JS files
  ordered_cache_behavior {
    path_pattern     = "*.js"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.js_library.bucket}"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400  # Cache JS files for 24 hours
    max_ttl                = 31536000  # 1 year
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = var.tags
}

# S3 bucket policy to allow CloudFront access
data "aws_iam_policy_document" "js_library_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.js_library.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.js_library.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "js_library" {
  bucket = aws_s3_bucket.js_library.id
  policy = data.aws_iam_policy_document.js_library_policy.json
}