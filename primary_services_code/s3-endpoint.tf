resource "aws_vpc_endpoint" "s3-private" {
  vpc_id       = aws_vpc.New_Customer_VPC.id
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [ aws_route_table.Private_RT.id ]
  tags = {
    Name = "${var.CUSTOMER_NAME}-s3-private"
  }
}


resource "aws_vpc_endpoint" "s3-public" {
  vpc_id       = aws_vpc.New_Customer_VPC.id
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [ aws_route_table.Public_RT.id ]
  tags = {
    Name = "${var.CUSTOMER_NAME}-s3-public"
  }
}


resource "aws_vpc_endpoint_policy" "s3-private-policy" {
  vpc_endpoint_id = aws_vpc_endpoint.s3-private.id
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [ "arn:aws:s3:::${var.CUSTOMER_NAME}.vultara.com/*","arn:aws:s3:::${var.CUSTOMER_NAME}.vultara.com",#changed to public when making the new archteture
                    "arn:aws:s3:::${var.CUSTOMER_NAME}-reports-bucket/*","arn:aws:s3:::${var.CUSTOMER_NAME}-reports-bucket",
                    "arn:aws:s3:::${var.CUSTOMER_NAME}-cve-cpe-bucket/*","arn:aws:s3:::${var.CUSTOMER_NAME}-cve-cpe-bucket",
                    "arn:aws:s3:::${var.CUSTOMER_NAME}-help-doc-bucket/*","arn:aws:s3:::${var.CUSTOMER_NAME}-help-doc-bucket" ,
                     "arn:aws:s3:::docker-images-prod/*","arn:aws:s3:::docker-images-prod",
                     "arn:aws:s3:::prod-us-east-1-starport-layer-bucket/*","arn:aws:s3:::prod-us-east-1-starport-layer-bucket"],
      "Principal": "*"
    }
  ]
})
}


resource "aws_vpc_endpoint_policy" "s3-public-policy" {
  vpc_endpoint_id = aws_vpc_endpoint.s3-public.id
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [ "arn:aws:s3:::${var.CUSTOMER_NAME}-production-file-bucket/*","arn:aws:s3:::${var.CUSTOMER_NAME}-production-file-bucket",
                     "arn:aws:s3:::docker-images-prod/*","arn:aws:s3:::docker-images-prod",
                     "arn:aws:s3:::prod-us-east-1-starport-layer-bucket/*","arn:aws:s3:::prod-us-east-1-starport-layer-bucket" ],
      "Principal": "*"
    }
  ]
})
}

