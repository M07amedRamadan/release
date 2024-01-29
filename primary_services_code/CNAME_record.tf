resource "aws_route53_record" "www-dev" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.CUSTOMER_NAME}.vultara.com"
  type    = "CNAME"
  ttl     = 3600
  records = ["${var.cloudfront_id}"]
}

#data "aws_route53_zone" "vultara_zone" {
#  name = "example.com"  # Replace with the actual domain name
#}

output "hosted_zone" {
value   =    aws_route53_zone.primary.zone_id 
}
