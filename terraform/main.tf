# No change required in this file

resource "aws_vpc" "New_Customer_VPC" {
  count         = var.Application_type == "Vultara" ? 1 : 0
  cidr_block           = "10.33.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.CUSTOMER_NAME}-VPC-prod"
  }
}

resource "aws_subnet" "public_1" {
  count         = var.Application_type == "Vultara" ? 1 : 0
  vpc_id        = aws_vpc.New_Customer_VPC.id
  cidr_block    = cidrsubnet(aws_vpc.New_Customer_VPC.cidr_block, 3, 0) # Index 0
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.CUSTOMER_NAME}-public-sub-1"
  }
}