#No need to change except at your keys/values after adding the secrets at GitHub secrets.
resource "aws_secretsmanager_secret" "secret" {
  name = "New-secret"
}

data "aws_secretsmanager_secret_version" "old_secret" {
  secret_id = "trial-application-user"
}

resource "aws_secretsmanager_secret_version" "new_secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(local.updated_secret)
}

# Decode the existing secret JSON
locals {
  new_user_url = "mongodb+srv://${var.CustomerName}_user:${random_password.db_password.result}@cluster0.ghbhwuc.mongodb.net/${var.CustomerName}_DB?retryWrites=true&w=majority"
  existing_secret = jsondecode(data.aws_secretsmanager_secret_version.old_secret.secret_string)
  updated_secret = merge(
    # local.existing_secret,
  # Update specific values in the secret
  {
    "CVE_API_KEY" = lookup(local.existing_secret, "CVE_API_KEY", null),
    "ATLASDB_ALGOREAD" = lookup(local.existing_secret, "ATLASDB_ALGOREAD", null),
    "ATLASDB_CUSTOMERLICENSE" = lookup(local.existing_secret, "ATLASDB_CUSTOMERLICENSE", null),
    "ATLASDB_CUSTOMERDIAGNOSTIC" = lookup(local.existing_secret, "ATLASDB_CUSTOMERDIAGNOSTIC", null),
    "ATLASDB_MONITORING_PROD" = lookup(local.existing_secret, "ATLASDB_MONITORING_PROD", null),
    "ATLASDB_HELPREAD" = lookup(local.existing_secret, "ATLASDB_HELPREAD", null),
    "ATLASDB_DATAANALYTICS" = lookup(local.existing_secret, "ATLASDB_DATAANALYTICS", null),
    "ATLASDB_COMPONENTREAD" = lookup(local.existing_secret, "ATLASDB_COMPONENTREAD", null),
    "ACCESS_TOKEN" = "${random_password.access_token.result}",
    "JWT_SECRET_KEY" = "${random_password.JWT_SECRET_KEY.result}",
    "JWT_ACCESS_TOKEN_SECRET" = "${random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result}",
    "JWT_REFRESH_TOKEN_SECRET" = "${random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result}",
    "ATLASDB" = "${local.new_user_url}",
    "ATLASDB_USERACCESS" = "${local.new_user_url}",
  }
  )
}

#Random secrets generator 
resource "random_password" "access_token" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "random_password" "JWT_SECRET_KEY" {
  length  = 256
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "random_password" "JWT_ACCESS_REFRESH_TOKEN_SECRET" {
  length  = 256
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "random_password" "db_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric = true
}