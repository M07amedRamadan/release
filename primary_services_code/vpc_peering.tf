resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id      = "vpc-01ff5914b2252b003"              # ID of the existing VPC in us-east-1
  peer_vpc_id = aws_vpc.New_Customer_VPC.id          # ID of the new VPC in another region
  peer_region = "us-west-1"                          # Region of the peer VPC
  auto_accept = true

tags = {
    Name = "VPC-Peering-Vultara-vpc-to-${aws_vpc.New_Customer_VPC.name}"
  }
}

