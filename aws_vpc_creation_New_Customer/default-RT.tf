resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.New_Customer_VPC.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.New_Customer_VPC_nat_gw.id # Replace with the ID of your NAT Gateway
  }

  tags = {
    Name = "Private_RT"
  }
}

