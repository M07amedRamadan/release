resource "aws_route53_record" "cname_record" {
  for_each = toset(local.resources)
  zone_id = data.aws_route53_zone.vultara_zone.zone_id
# bucket = each.value "${var.CUSTOMER_NAME}.vultara.com"
  name    = "${each.value}.vultara.com"
  type    = "CNAME"
  ttl     = 3600
  records = ["${aws_cloudfront_distribution.CloudFront[each.key].domain_name}"]
}

data "aws_route53_zone" "vultara_zone" {
  name = "vultara.com"  # Replace with the actual domain name
}
