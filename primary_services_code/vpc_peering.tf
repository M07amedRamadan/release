provider "aws" {
  alias  = "peer"
  region = "us-east-1" #vultara vpc region
}

# Create a VPC peering connection
resource "aws_vpc_peering_connection" "peering_connection" {
  peer_region = "us-east-1"                          # Region of the vultara VPC
  #peer_vpc_id      = data.aws_vpc.vultara_vpc.id
  peer_vpc_id =   "vpc-01ff5914b2252b003"      # ID of Vultara VPC
  vpc_id       = aws_vpc.New_Customer_VPC.id


tags = {
    Name = "VPC-Peering-Vultara-${var.CUSTOMER_NAME}-vpc"
    Side = "Requester"
  }
}
 
#Retreiving the vultara VPC data.
data "aws_vpc" "vultara_vpc" {
  provider = aws.peer
  id = "vpc-01ff5914b2252b003"  # vultara vpc_id, Replace with the ID of your VPC
}

output "vultara_vpc_cidr_block" {
value= data.aws_vpc.vultara_vpc.cidr_block
}






