resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.New_Customer_VPC.id
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [ aws_route_table.Public_RT.id, aws_route_table.Private_RT.id ]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [ "arn:aws:s3:::${var.CUSTOMER_NAME}.vultara.com/*","arn:aws:s3:::${var.CUSTOMER_NAME}.vultara.com" ],
      "Principal": "*"
    }
  ]
}
EOF
}
