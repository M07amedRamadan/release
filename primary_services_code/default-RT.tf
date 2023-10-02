# No change required in this file

resource "aws_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.New_Customer_VPC.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.New_Customer_VPC_nat_gw.id
  }

  route {
    cidr_block                = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  }

  tags = {
    Name = "${var.CUSTOMER_NAME}-Private_RT"
  }
}
resource "aws_route_table_association" "Private_subnet_association_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.default_route_table.id
}

resource "aws_route_table_association" "Private_subnet_association_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.default_route_table.id
}
