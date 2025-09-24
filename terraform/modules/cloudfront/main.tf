# S3 Bucket for JavaScript Analytics Library
# This bucket stores the browser analytics JavaScript library that gets distributed via CloudFront.
# Users will load this JS from their browser extensions to send tracking data back to our platform.
resource "aws_s3_bucket" "js_library" {
  bucket = var.js_library_bucket_name
  
  tags = var.tags
}

# enable versioning so we can track changes to our js library over time
resource "aws_s3_bucket_versioning" "js_library" {
  bucket = aws_s3_bucket.js_library.id
  versioning_configuration {
    status = "Enabled"  # helps with rollbacks if we push a bad version
  }
}

# encrypt the bucket because security is important even for public js files
resource "aws_s3_bucket_server_side_encryption_configuration" "js_library" {
  bucket = aws_s3_bucket.js_library.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # using aes256 instead of kms to keep costs down
    }
  }
}

# block all public access since we want cloudfront to be the only way to access files
resource "aws_s3_bucket_public_access_block" "js_library" {
  bucket = aws_s3_bucket.js_library.id

  block_public_acls       = true  # no public acls allowed
  block_public_policy     = true  # no public bucket policies
  ignore_public_acls      = true  # ignore any existing public acls
  restrict_public_buckets = true  # restrict public bucket access entirely
}

# CloudFront Origin Access Control (OAC)
# This replaces the older OAI approach and gives cloudfront permission to read from our private bucket
resource "aws_cloudfront_origin_access_control" "js_library" {
  name                              = "${var.project_name}-${var.environment}-js-library-oac"
  description                       = "OAC for JS library S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"    # always sign requests to s3
  signing_protocol                  = "sigv4"     # use aws signature version 4
}

# CloudFront Distribution for Global JS Library Delivery
# This distributes our browser analytics library to edge locations worldwide for fast loading
resource "aws_cloudfront_distribution" "js_library" {
  origin {
    domain_name              = aws_s3_bucket.js_library.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.js_library.id
    origin_id                = "S3-${aws_s3_bucket.js_library.bucket}"
  }

  enabled             = true               # obviously we want this enabled
  is_ipv6_enabled     = true              # support ipv6 for future-proofing
  comment             = "Browser Analytics JS Library Distribution"
  default_root_object = "index.html"      # fallback file if someone hits the root

  # default cache behavior for most files
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]  # allow all http methods
    cached_methods   = ["GET", "HEAD"]                                               # but only cache get and head
    target_origin_id = "S3-${aws_s3_bucket.js_library.bucket}"

    forwarded_values {
      query_string = false  # don't forward query params to s3

      cookies {
        forward = "none"    # don't forward cookies either
      }
    }

    viewer_protocol_policy = "redirect-to-https"  # force https for security
    min_ttl                = 0                    # allow immediate invalidation
    default_ttl            = 3600                 # cache for 1 hour by default
    max_ttl                = 86400                # max cache time is 24 hours
    compress               = true                 # compress files to save bandwidth
  }

  # special cache behavior for javascript files - we want these cached longer
  ordered_cache_behavior {
    path_pattern     = "*.js"                            # only matches .js files
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]        # only read operations for js files
    cached_methods   = ["GET", "HEAD"]                   # cache get and head responses
    target_origin_id = "S3-${aws_s3_bucket.js_library.bucket}"

    forwarded_values {
      query_string = false                               # still no query strings
      headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]  # forward cors headers

      cookies {
        forward = "none"                                 # no cookies for js files
      }
    }

    min_ttl                = 0                           # can still invalidate immediately
    default_ttl            = 86400                       # cache js files for 24 hours by default
    max_ttl                = 31536000                    # max cache is 1 year for js files
    compress               = true                        # definitely compress javascript
    viewer_protocol_policy = "redirect-to-https"        # force https
  }

  price_class = "PriceClass_100"  # use cheapest price class (us, canada, europe)

  restrictions {
    geo_restriction {
      restriction_type = "none"     # no geo restrictions for now
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true  # use default cloudfront cert for now
  }

  tags = var.tags
}

# S3 Bucket Policy to Allow CloudFront Access
# This policy allows only our specific cloudfront distribution to read files from the s3 bucket
data "aws_iam_policy_document" "js_library_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]  # only cloudfront service
    }

    actions = ["s3:GetObject"]  # only allow reading objects

    resources = ["${aws_s3_bucket.js_library.arn}/*"]  # all objects in the bucket

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"                        # must come from our specific distribution
      values   = [aws_cloudfront_distribution.js_library.arn]
    }
  }
}

# attach the policy to the bucket
resource "aws_s3_bucket_policy" "js_library" {
  bucket = aws_s3_bucket.js_library.id
  policy = data.aws_iam_policy_document.js_library_policy.json
}