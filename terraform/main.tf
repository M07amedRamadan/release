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

  # Update specific values in the secret
  updated_secret = {
    "ACCESS_TOKEN" = "${local.existing_secret["ACCESS_TOKEN"]} random_password.access_token.result",
    "JWT_SECRET_KEY" = "${local.existing_secret["JWT_SECRET_KEY"]} random_password.JWT_SECRET_KEY.result",
    "JWT_ACCESS_TOKEN_SECRET" = "${local.existing_secret["JWT_ACCESS_TOKEN_SECRET"]} random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result",
    "JWT_REFRESH_TOKEN_SECRET" = "${local.existing_secret["JWT_REFRESH_TOKEN_SECRET"]} random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result",

    # for key, value in local.existing_secret :
    # key => (
    #   key == "ACCESS_TOKEN"    ? random_password.access_token.result :
    #   key == "JWT_SECRET_KEY"      ? random_password.JWT_SECRET_KEY.result  :
    #   key == "JWT_ACCESS_TOKEN_SECRET"    ? random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result :
    #   key == "JWT_REFRESH_TOKEN_SECRET"    ? random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result :
    #   value
    # )
  }
}

# locals {
#   existing_secret = jsondecode(data.aws_secretsmanager_secret_version.old_secret.secret_string)

#   # Update specific values in the secret
#   updated_secret = {
#     "EXISTING_STRING_KEY" = "${local.existing_secret["EXISTING_STRING_KEY"]} new_value_to_append",

#     for key, value in local.existing_secret :
#     key => (
#       key == "ACCESS_TOKEN"    ? random_password.access_token.result :
#       key == "JWT_SECRET_KEY"      ? random_password.JWT_SECRET_KEY.result  :
#       key == "JWT_ACCESS_TOKEN_SECRET"    ? random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result :
#       key == "JWT_REFRESH_TOKEN_SECRET"    ? random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result :
#       value
#     )
#   }
# }


# resource "aws_secretsmanager_secret_version" "secret_version" {
#   secret_id = aws_secretsmanager_secret.secret.id
#   secret_string = jsonencode({
#     ACCESS_TOKEN               = random_password.access_token.result,
#     JWT_SECRET_KEY             = random_password.JWT_SECRET_KEY.result,
#     JWT_ACCESS_TOKEN_SECRET    = random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result,
#     JWT_REFRESH_TOKEN_SECRET   = random_password.JWT_ACCESS_REFRESH_TOKEN_SECRET.result,
#   })
# }

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


# AWS Secrets Manager Secret name random creation
# resource "random_string" "secret_suffix" {
#   length  = 8
#   special = false
# }
