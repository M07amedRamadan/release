# No change required in this file

resource "aws_vpc" "New_Customer_VPC" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.CUSTOMER_NAME}-VPC-prod"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.New_Customer_VPC.id
  cidr_block = var.public_subnet_1
  availability_zone = "us-west-2a"

  tags = {
    Name = "${var.CUSTOMER_NAME}-public-sub-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.New_Customer_VPC.id
  cidr_block = var.public_subnet_2
  availability_zone = "us-west-2b"

  tags = {
    Name = "${var.CUSTOMER_NAME}-public-sub-2"
  }
}


resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.New_Customer_VPC.id
  cidr_block = var.private_subnet_1
  availability_zone = "us-west-2a"

  tags = {
    Name = "${var.CUSTOMER_NAME}-private-sub-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.New_Customer_VPC.id
  cidr_block = var.private_subnet_2
  availability_zone = "us-west-2b"

  tags = {
    Name = "${var.CUSTOMER_NAME}-private-sub-2"
  }
}
