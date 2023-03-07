resource "aws_internet_gateway" "New_Customer_VPC_Internet_GW" {
  vpc_id = aws_vpc.New_Customer_VPC.id

  tags = {
    Name = "${var.vpc_name}-Internet-GW"
  }
}