#peer region to be used at accepter resource.
provider "aws" {
  alias  = "mongo-peer"
  region = "us-east-1"

  # Accepter's credentials if in another account.
}

# Define your MongoDB Atlas VPC CIDR block
# This should be retrieved from your MongoDB Atlas account
variable "mongodb_atlas_cidr" {
  default = "192.168.248.0/21"  # Replace with your MongoDB Atlas CIDR block
}

# Create VPC peering connection
resource "aws_vpc_peering_connection" "mongodb_peering_connection" {
  peer_region          = "us-east-1"  # Replace with your MongoDB Atlas region
  peer_owner_id        = "126124458305"
  peer_vpc_id          = "vpc-0c2f60a694a109ae5"  # Replace with your MongoDB Atlas VPC ID
  vpc_id         =   aws_vpc.New_Customer_VPC.id  

  tags = {
    Name = "VPC-Peering-MongoDB-${var.CUSTOMER_NAME}-VPC"
  }
}


# Update route tables in your AWS VPC
resource "aws_route" "my_route" {
  route_table_id         = aws_vpc.New_Customer_VPC.main_route_table_id  # Replace with your AWS route table ID
  destination_cidr_block = var.mongodb_atlas_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.mongodb_peering_connection.id
}

