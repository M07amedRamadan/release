provider "aws" {
  alias  = "peer"
  region = "us-east-1" #vultara vpc region
}

resource "aws_vpc_peering_connection" "peering_connection" {
  peer_region    = "us-east-1"                          # Region of the vultara VPC
  peer_vpc_id    = data.aws_vpc.vultara_vpc.id
  vpc_id         =   aws_vpc.New_Customer_VPC.id          # ID of the new VPC in another region

tags = {
    Name = "VPC-Peering-Vultara-${var.CUSTOMER_NAME}-VPC"
    Side = "Requester"
  }
}

# auto accept as the vpc in another region
 resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer #provide the peer region
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  auto_accept               = true
  tags = {
    Name = "VPC-Peering-Vultara-${var.CUSTOMER_NAME}-VPC"
    Side = "Accepter"
  }
}

# Create a route in New_Customer VPC's route table to the Vultara VPC via the peering connection
 resource "aws_route" "route_from_New_Customer_to_vultara_vpc" {
   route_table_id             = aws_vpc.New_Customer_VPC.main_route_table_id
   destination_cidr_block     = "10.0.1.250/32" # the cidr_block of the Vultara VPC
   vpc_peering_connection_id  = aws_vpc_peering_connection.peering_connection.id
 }

 # Create a route in the Vultara VPC's route table to New_Customer VPC via the peering connection
 resource "aws_route" "route_from_vultara_to_New_Customer_report_generator" {
   provider               = aws.peer
   route_table_id         = data.aws_route_table.specific_route_table.route_table_id
   destination_cidr_block  = "${aws_instance.report_generator.private_ip}/32" # Using private IP since it's within the VPC
   vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
 }

 # Create a route in the Vultara VPC's route table to New_Customer VPC via the peering connection
 resource "aws_route" "route_from_vultara_to_New_Customer_vultara_scheduler" {
   provider               = aws.peer
   route_table_id         = data.aws_route_table.specific_route_table.route_table_id
   destination_cidr_block = "${aws_instance.vultara_scheduler.private_ip}/32" # Using private IP since it's within the VPC
   vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
 }
 
#Retreiving the vultara VPC data.
data "aws_vpc" "vultara_vpc" {
  provider = aws.peer
  id = "vpc-01ff5914b2252b003"  # vultara vpc_id, Replace with the ID of your VPC
}

data "aws_route_table" "specific_route_table" {
  provider    = aws.peer
  vpc_id      = data.aws_vpc.vultara_vpc.id
  route_table_id = "rtb-0671ab4ce03160f84"  # Replace with the ID of the specific route table
}
