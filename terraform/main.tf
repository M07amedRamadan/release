# No change required in this file

resource "aws_vpc" "New_Customer_VPC" {
  cidr_block           = "10.33.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.CUSTOMER_NAME}-VPC-prod"
  }
}