# No change required in this file
# Create a VPC peering connection between the Vultara VPC and the new Customer VPC


##resource "aws_vpc_peering_connection" "peering_connection" {
##  vpc_id      = "vpc-01ff5914b2252b003"     # ID of the existing VPC
##  peer_vpc_id = aws_vpc.New_Customer_VPC.id # ID of the new VPC
##  auto_accept = true
##
##  tags = {
##    Name = "${var.CUSTOMER_NAME}-vpc-vultara-vpc-peering"
##  }
##}
