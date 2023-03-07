# Create a VPC peering connection between the existing VPC and the new VPC
resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id      = "vpc-01ff5914b2252b003"     # ID of the existing VPC
  peer_vpc_id = aws_vpc.New_Customer_VPC.id # ID of the new VPC
  auto_accept = true

  tags = {
    Name = "${var.vpc_name}-vultara-vpc-peering"
  }
}