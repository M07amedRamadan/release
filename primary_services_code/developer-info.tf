output "public-1-id" {
  value = aws_subnet.public_1.id
}

output "public-2-id" {
  value = aws_subnet.public_2.id
}

output "private-1-id" {
  value = aws_subnet.private_1.id
}

output "private-2-id" {
  value = aws_subnet.private_2.id
}

output "security-group-id" {
  value = aws_default_security_group.New_Customer_VPC_SG.id
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
