#No need to change only ad your keys/values
# resource "aws_secretsmanager_secret" "example_secret" {
#   name = "${var.CUSTOMER_NAME}-secret"
# }

# resource "aws_secretsmanager_secret_version" "example_secret_version" {
#   secret_id = aws_secretsmanager_secret.example_secret.id
#   secret_string = jsonencode({
#     key1 = "value1",
#     key2 = "value2",
#     key3 = "value3",
#     // Add more key-value pairs as needed
#   })
# }
