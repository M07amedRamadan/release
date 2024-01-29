provider "aws" {
  alias  = "peer"
  region = "us-east-1" #vultara vpc region
}

resource "aws_vpc_peering_connection" "peering_connection" {
  #peer_region = "us-east-1"                          # Region of the vultara VPC
  #vpc_id      = data.aws_vpc.vultara_vpc.id
  vpc_id       = "vpc-e630808d"
  peer_vpc_id = aws_vpc.New_Customer_VPC.id          # ID of the new VPC in another region

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
