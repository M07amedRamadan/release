provider "aws" {
  alias  = "peer"
  region = "us-east-1" #vultara vpc region
}

resource "aws_vpc_peering_connection" "peering_connection" {
  peer_region = "us-east-1"                          # Region of the peer VPC
  vpc_id      = "vpc-01ff5914b2252b003"              # ID of the vultara_vpc in us-east-1
  peer_vpc_id = aws_vpc.New_Customer_VPC.id          # ID of the new VPC in another region
                            
  

tags = {
    Name = "VPC-Peering-Vultara-${var.CUSTOMER_NAME}-vpc"
  }
}

# auto accept as the vpc in another region
 resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer #provide the peer region
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  auto_accept               = true

}

# Create a route in New_Customer VPC's route table to the Vultara VPC via the peering connection
 resource "aws_route" "route_from_New_Customer_to_vultara_vpc" {
   route_table_id         = aws_vpc.New_Customer_VPC.main_route_table_id
   destination_cidr_block = data.aws_vpc.vultara_vpc.cidr_block # the cidr_block of the Vultara VPC
   vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
 }

 # Create a route in the Vultara VPC's route table to New_Customer VPC via the peering connection
 resource "aws_route" "route_from_vultara_to_New_Customer_VPC" {
   provider               = aws.peer
   route_table_id         = data.aws_vpc.vultara_vpc.main_route_table_id
   destination_cidr_block = aws_vpc.New_Customer_VPC.cidr_block # the cidr_block of New_Customer VPC
   vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
 }
 
#Retreiving the vultara VPC data.
data "aws_vpc" "vultara_vpc" {
  provider = aws.peer
  id = "vpc-01ff5914b2252b003"  # vultara vpc_id, Replace with the ID of your VPC
}

output "vultara_vpc_id" {
value= aws_vpc.vultara_vpc.id
}
output "vultara_vpc_id" {
value= aws_vpc.vultara_vpc.cidr_block
}
