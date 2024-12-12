provider "mongodbatlas" {
  public_key  = var.public_key
  private_key = var.private_key
}

#retrieve ProjectID
data "mongodbatlas_project" "atlas-project" {
  name   = "DevDB"
}

#retrieve containerID
data "mongodbatlas_cluster" "my_cluster" {
  name = "Cluster0"
  project_id = data.mongodbatlas_project.atlas-project.id
}

resource "mongodbatlas_network_peering" "aws-atlas" {
  accepter_region_name   = var.region
  project_id             = data.mongodbatlas_project.atlas-project.id
  container_id           = data.mongodbatlas_cluster.my_cluster.container_id
  provider_name          = "AWS"
  route_table_cidr_block = aws_vpc.New_Customer_VPC.cidr_block
  vpc_id                 = aws_vpc.New_Customer_VPC.id
  aws_account_id         = "837491041518"
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas.connection_id
  auto_accept               = true
}

#retrieve mongo atlas VPC CIDR block to add route in AWS VPC route table
data "mongodbatlas_network_container" "container" {
  project_id             = data.mongodbatlas_project.atlas-project.id
  container_id           = data.mongodbatlas_cluster.my_cluster.container_id
}

resource "aws_route" "peeraccess" {
  route_table_id            = aws_default_route_table.Private_RT.id
  destination_cidr_block    = data.mongodbatlas_network_container.container.atlas_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas.connection_id
  depends_on                = [aws_vpc_peering_connection_accepter.peer]
}

resource "mongodbatlas_project_ip_access_list" "test" {
  project_id = data.mongodbatlas_project.atlas-project.id
  cidr_block = aws_vpc.New_Customer_VPC.cidr_block
  comment    = "cidr block for AWS VPC"
}
