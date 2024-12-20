resource "mongodbatlas_database_user" "db_user" {
  project_id         = data.mongodbatlas_project.aws_atlas.id
  username           = "${var.CUSTOMER_NAME}_user"
  password           = random_password.db_password.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "${var.CUSTOMER_NAME}_DB"
  }

  scopes {
    name = "Cluster0"
    type = "CLUSTER"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Generate a secure random password
resource "random_password" "db_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric = true
}

output "dbuser" {
  value = "${var.CUSTOMER_NAME}_user"
}

output "dbpass" {
  value = random_password.db_password.result
  sensitive = true
}