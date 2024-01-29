resource "aws_route53_record" "cname_record" {
  zone_id = data.aws_route53_zone.vultara_zone.zone_id
  name    = "${var.CUSTOMER_NAME}.vultara.com"
  type    = "CNAME"
  ttl     = 3600
  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
}

data "aws_route53_zone" "vultara_zone" {
  name = "vultara.com"  # Replace with the actual domain name
}

output "hosted_zone" {
value   =    data.aws_route53_zone.vultara_zone.zone_id 
}
