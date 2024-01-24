provider "aws" {
  alias  = "peer"
  region = "us-east-1"
}

resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id      = "vpc-01ff5914b2252b003"              # ID of the vultara_vpc in us-east-1
  peer_vpc_id = aws_vpc.New_Customer_VPC.id          # ID of the new VPC in another region
  peer_region = "us-east-1"                          # Region of the peer VPC
  auto_accept = true

tags = {
    Name = "VPC-Peering-Vultara-fakecustomer-vpc"
  }
}

# auto accept as the vpc in another region
 resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer #provide the peer region
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  auto_accept               = true

}

# Create a route in our VPC's route table to the  VPC via the peering connection
 resource "aws_route" "route_to_vultara_vpc" {
   route_table_id         = aws_vpc.Main-VPC.main_route_table_id
   destination_cidr_block = data.aws_vpc.vultara_vpc.cidr_block # the cidr_block of the Existing VPC
   vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
 }

 # Create a route in the VPC's route table to the our VPC via the peering connection
 resource "aws_route" "route_to_main_vpc" {
   provider               = aws.peer
   route_table_id         = data.aws_vpc.vultara_vpc.main_route_table_id
   destination_cidr_block = aws_vpc.Main-VPC.cidr_block # the cidr_block of Main VPC
   vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
 }
 
#Retreiving the vultara VPC data.
data "aws_vpc" "vultara_vpc" {
  provider = aws.peer
  id = "vpc-01ff5914b2252b003"  # Replace with the ID of your VPC
}


