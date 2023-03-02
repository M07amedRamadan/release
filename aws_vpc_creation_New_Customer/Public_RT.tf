resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.New_Customer_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.New_Customer_VPC_Internet_GW.id
  }

  tags = {
    Name = "Public_RT"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.Public_RT.id
}