#locals {
 # s3_origin_id = "terraform.vultara.com.s3-website-us-east-1.amazonaws.com"
#}

resource "aws_cloudfront_distribution" "s3_distribution" {

 #s3 origin for cloundfront
  origin {
    domain_name = "${var.bucket_name}.s3.${var.region}.amazonaws.com"
    origin_id   = "${var.bucket_name}.s3.${var.region}.amazonaws.com"
  }
 #Custom Type origin for Cloundfront 
  origin {
    domain_name = "${var.bucket_name}.s3-website-${var.region}.amazonaws.com"
    origin_id   = "${var.bucket_name}.s3-website-${var.region}.amazonaws.com"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

is_ipv6_enabled = true
  enabled = true
  default_root_object = "index.html"


#Error Pages CloudFront
custom_error_response {
      error_code           = 404
      response_code        = 200
      response_page_path   = "/index.html"
      error_caching_min_ttl = 10
    }

    custom_error_response {
      error_code           = 403
      response_code        = 200
      response_page_path   = "/index.html"
      error_caching_min_ttl = 10
    }

    #Cache Behavior for CloudFront
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.bucket_name}.s3-website-${var.region}.amazonaws.com"
    cache_policy_id             = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }

  aliases = ["${var.bucket_name}"]
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
    Environment = var.environment
  }

  viewer_certificate {
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
  }
}