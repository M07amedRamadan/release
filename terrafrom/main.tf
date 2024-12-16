#No need to change except at your keys/values after adding the secrets at GitHub secrets.
resource "aws_secretsmanager_secret" "secret" {
  name = "Test-secret"
}

data "aws_secretsmanager_secret_version" "old_secret" {
  secret_id = "<old-secret-id>"
}
resource "aws_secretsmanager_secret" "new_secret" {
  name = "<new-secret-name>"
}

resource "aws_secretsmanager_secret_version" "new_secret_version" {
  secret_id     = aws_secretsmanager_secret.new_secret.id
  secret_string = data.aws_secretsmanager_secret_version.old_secret.secret_string
}


(* resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode({
    ACCESS_TOKEN               = random_password.access_token.result,
    JWT_SECRET_KEY             = random_password.JWT_SECRET_KEY.result,
    JWT_ACCESS_TOKEN_SECRET    = random_password.jwt_secret.result,
    JWT_REFRESH_TOKEN_SECRET   = random_password.jwt_secret.result,
    CLOUDFRONT_ID              = aws_cloudfront_distribution.s3_distribution.id,
  })
}

#Random secrets generator 
resource "random_password" "access_token" {
  length  = 32
  special = false
}

resource "random_password" "jwt_secret" {
  length  = 256
  special = false
}

resource "random_password" "JWT_SECRET_KEY" {
  length  = 256
  special = false
}

# AWS Secrets Manager Secret name random creation
resource "random_string" "secret_suffix" {
  length  = 8
  special = false
} *)
