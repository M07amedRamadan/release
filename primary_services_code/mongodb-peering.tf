#peer region to be used at accepter resource.
provider "aws" {
  alias  = "mongo-peer"
  region = "us-east-1" #MongoDb region

  # Accepter's credentials if in another account (enter the MongoDB).
}

# Define your MongoDB Atlas VPC CIDR block
# This should be retrieved from your MongoDB Atlas account
variable "mongodb_atlas_cidr" {
  default = "192.168.248.0/21"  # Replace with your MongoDB Atlas CIDR block
}

# Create VPC peering connection
resource "aws_vpc_peering_connection" "my_peering_connection_mongo" {
  peer_vpc_id          = "vpc-0c2f60a694a109ae5"  # Replace with your MongoDB Atlas VPC ID
  vpc_id               = aws_vpc.New_Customer_VPC.id
  peer_owner_id        = "126124458305" #Mongodb Account ID
  peer_region          = "us-east-1"  # Replace with your MongoDB Atlas region
  #auto_accept               = true

  tags = {
    Name = "MyVPCPeeringConnection-MongoDB"
  }
}
# If auto-accept for peering does not work use the peering_connection_accpter
# To auto-accept as the VPC in another region
#  resource "aws_vpc_peering_connection_accepter" "peer" {
#   provider                  = aws.mongo-peer #provide the peer region
#   vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection_mongo.id
#   auto_accept               = true

#   tags = {
#     Side = "Accepter"
#   }
# }

#Add route from NewCustomer to MongoDB
resource "aws_route" "route_from_NewCustomer_to_MongoDB" {
  route_table_id         = aws_vpc.New_Customer_VPC.main_route_table_id  # Replace with your AWS route table ID
  destination_cidr_block = var.mongodb_atlas_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.my_peering_connection_mongo.id
}

