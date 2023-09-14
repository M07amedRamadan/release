# No change required in this file
# cloudfront distrubution # 1
resource "aws_cloudfront_distribution" "s3_distribution_1" {

  origin {
    domain_name = "${var.SERVICE_NAME_1}.vultara.com.s3.${var.region}.amazonaws.com"
    origin_id   = "${var.SERVICE_NAME_1}.vultara.com.s3.${var.region}.amazonaws.com"
  }

  origin {
    domain_name = "${var.SERVICE_NAME_1}.vultara.com.s3-website-${var.region}.amazonaws.com"
    origin_id   = "${var.SERVICE_NAME_1}.vultara.com.s3-website-${var.region}.amazonaws.com"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  is_ipv6_enabled     = true
  enabled             = true
  default_root_object = "index.html"


  #Error Pages CloudFront
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  #Cache Behavior for CloudFront
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.SERVICE_NAME_1}.vultara.com.s3-website-${var.region}.amazonaws.com"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }

  aliases     = ["${var.SERVICE_NAME_1}.vultara.com"]
  price_class = "PriceClass_All"

  # Geographical Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  #CloudFront Tag
  tags = {
    Environment = "Production"
  }

  viewer_certificate {
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
    acm_certificate_arn            = "arn:aws:acm:us-east-1:837491041518:certificate/74e193b1-9bae-49cd-af83-bc3f05ccbba1"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

# Cloudfront Distribution # 2

resource "aws_cloudfront_distribution" "s3_distribution_2" {

  origin {
    domain_name = "${var.SERVICE_NAME_2}.vultara.com.s3.${var.region}.amazonaws.com"
    origin_id   = "${var.SERVICE_NAME_2}.vultara.com.s3.${var.region}.amazonaws.com"
  }

  origin {
    domain_name = "${var.SERVICE_NAME_2}.vultara.com.s3-website-${var.region}.amazonaws.com"
    origin_id   = "${var.SERVICE_NAME_2}.vultara.com.s3-website-${var.region}.amazonaws.com"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  is_ipv6_enabled     = true
  enabled             = true
  default_root_object = "index.html"


  #Error Pages CloudFront
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  #Cache Behavior for CloudFront
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.SERVICE_NAME_2}.vultara.com.s3-website-${var.region}.amazonaws.com"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }

  aliases     = ["${var.SERVICE_NAME_2}.vultara.com"]
  price_class = "PriceClass_All"

  # Geographical Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  #CloudFront Tag
  tags = {
    Environment = "Production"
  }

  viewer_certificate {
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
    acm_certificate_arn            = "arn:aws:acm:us-east-1:837491041518:certificate/74e193b1-9bae-49cd-af83-bc3f05ccbba1"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

# Cloudfront Distribution # 3

resource "aws_cloudfront_distribution" "s3_distribution_3" {

  origin {
    domain_name = "${var.SERVICE_NAME_3}.vultara.com.s3.${var.region}.amazonaws.com"
    origin_id   = "${var.SERVICE_NAME_3}.vultara.com.s3.${var.region}.amazonaws.com"
  }

  origin {
    domain_name = "${var.SERVICE_NAME_3}.vultara.com.s3-website-${var.region}.amazonaws.com"
    origin_id   = "${var.SERVICE_NAME_3}.vultara.com.s3-website-${var.region}.amazonaws.com"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  is_ipv6_enabled     = true
  enabled             = true
  default_root_object = "index.html"


  #Error Pages CloudFront
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  #Cache Behavior for CloudFront
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.SERVICE_NAME_3}.vultara.com.s3-website-${var.region}.amazonaws.com"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }

  aliases     = ["${var.SERVICE_NAME_3}.vultara.com"]
  price_class = "PriceClass_All"

  # Geographical Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  #CloudFront Tag
  tags = {
    Environment = "Production"
  }

  viewer_certificate {
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
    acm_certificate_arn            = "arn:aws:acm:us-east-1:837491041518:certificate/74e193b1-9bae-49cd-af83-bc3f05ccbba1"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

# Cloudfront Distribution # 4

resource "aws_cloudfront_distribution" "s3_distribution_4" {

  origin {
    domain_name = "${var.SERVICE_NAME_4}.vultara.com.s3.${var.region}.amazonaws.com"
    origin_id   = "${var.SERVICE_NAME_4}.vultara.com.s3.${var.region}.amazonaws.com"
  }

  origin {
    domain_name = "${var.SERVICE_NAME_4}.vultara.com.s3-website-${var.region}.amazonaws.com"
    origin_id   = "${var.SERVICE_NAME_4}.vultara.com.s3-website-${var.region}.amazonaws.com"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  is_ipv6_enabled     = true
  enabled             = true
  default_root_object = "index.html"


  #Error Pages CloudFront
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  #Cache Behavior for CloudFront
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.SERVICE_NAME_4}.vultara.com.s3-website-${var.region}.amazonaws.com"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }

  aliases     = ["${var.SERVICE_NAME_4}.vultara.com"]
  price_class = "PriceClass_All"

  # Geographical Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  #CloudFront Tag
  tags = {
    Environment = "Production"
  }

  viewer_certificate {
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
    acm_certificate_arn            = "arn:aws:acm:us-east-1:837491041518:certificate/74e193b1-9bae-49cd-af83-bc3f05ccbba1"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}