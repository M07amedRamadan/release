#No need to change except at your keys/values after adding the secrets at GitHub secrets.
resource "aws_secretsmanager_secret" "secret" {
  name = "Test-secret"
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
  existing_secret = jsondecode(data.aws_secretsmanager_secret_version.old_secret.secret_string)
  updated_secret = merge(
    local.existing_secret,
  # Update specific values in the secret
  {
    "CVE_API_KEY" = contains(keys(local.existing_secret), "${value}"),
    "ACCESS_TOKEN" = contains(keys(local.existing_secret), "${random_password.access_token.result}") ? "${random_password.access_token.result}" : "${random_password.access_token.result}",
    "JWT_SECRET_KEY" = contains(keys(local.existing_secret), "${random_password.JWT_SECRET_KEY.result}") ? "${random_password.JWT_SECRET_KEY.result}" : "${random_password.JWT_SECRET_KEY.result}",
    "JWT_ACCESS_TOKEN_SECRET" = contains(keys(local.existing_secret), "${random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result}") ? "${random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result}" : "${random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result}",
    "JWT_REFRESH_TOKEN_SECRET" = contains(keys(local.existing_secret), "${random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result}") ? "${random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result}" : "${random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result}",
  }
  )
}

#Random secrets generator 
resource "random_password" "access_token" {
  length  = 32
  special = true
  upper   = true
  lower   = true
  numeric = true
}

resource "random_password" "JWT_SECRET_KEY" {
  length  = 256
  special = true
  upper   = true
  lower   = true
  numeric = true
}

resource "random_password" "JWT_ACCESS_REFRESH_TOKEN_SECRET" {
  length  = 256
  special = true
  upper   = true
  lower   = true
  numeric = true
}