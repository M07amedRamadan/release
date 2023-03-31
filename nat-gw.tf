# No change required in this file

resource "aws_eip" "New_Customer_VPC_EIP" {
  vpc = true

  tags = {
    Name = "${var.CUSTOMER_NAME}-EI-nat"
  }
}

resource "aws_nat_gateway" "New_Customer_VPC_nat_gw" {
  allocation_id = aws_eip.New_Customer_VPC_EIP.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "${var.CUSTOMER_NAME}-NAT-GW"
  }

  depends_on = [aws_internet_gateway.New_Customer_VPC_Internet_GW]
}

