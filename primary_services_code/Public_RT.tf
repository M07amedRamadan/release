# No change required in this file

resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.New_Customer_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.New_Customer_VPC_Internet_GW.id
  }

  tags = {
    Name = "${var.CUSTOMER_NAME}-Public_RT"
  }
}

resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.Public_RT.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.Public_RT.id
}