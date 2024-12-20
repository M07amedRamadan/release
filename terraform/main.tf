# No change required in this file

resource "aws_vpc" "New_Customer_VPC" {
  for_each = toset(local.resources)
  count = local.countNum[each.key]
  
  cidr_block           = "10.33.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.CUSTOMER_NAME}-VPC-prod"
  }
}