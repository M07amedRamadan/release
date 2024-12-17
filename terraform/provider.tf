provider "aws" {
  region     = var.region
}


resource "random_password" "db_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric = true
}