data "aws_iam_role" "vultara_role" {
  name = "scheduler-server-role"  # Replace with the name of your existing IAM role
}

# IAM Instance Profile
# Used to attach iam-role with ec2 
resource "aws_iam_instance_profile" "instance_profile" {
  name = "Instance-profile"
  role = data.aws_iam_role.vultara_role.name
}

# resource "aws_iam_role" "report_role" {
#   name = "${var.CUSTOMER_NAME}_report_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "s3_access_policy" {
#   name        = "S3AccessPolicy"
#   description = "Policy to grant S3 access"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = "s3:*",
#         Resource = [
#           "arn:aws:s3:::${var.CUSTOMER_NAME}-reports-bucket",
#           "arn:aws:s3:::${var.CUSTOMER_NAME}-reports-bucket/*"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
#   role       = aws_iam_role.report_role.name
#   policy_arn = aws_iam_policy.s3_access_policy.arn
# }

# resource "aws_iam_role_policy_attachment" "ContainerRegistry" {
#   role       = aws_iam_role.report_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
# }

# resource "aws_iam_role_policy_attachment" "AmazonSSMManaged" {
#   role       = aws_iam_role.report_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_iam_role_policy_attachment" "send_email_only" {
#   role       = aws_iam_role.report_role.name
#   policy_arn = "arn:aws:iam::837491041518:policy/send_email_only_policy"
# }

# resource "aws_iam_role_policy_attachment" "secret-mgr-read" {
#   role       = aws_iam_role.report_role.name
#   policy_arn = "arn:aws:iam::837491041518:policy/secret-mgr-read-all-secret-policy"
# }

# resource "aws_iam_role_policy_attachment" "mgr-assume-role" {
#   role       = aws_iam_role.report_role.name
#   policy_arn = "arn:aws:iam::837491041518:policy/secret-mgr-assume-role-policy"
# }

# resource "aws_iam_role_policy_attachment" "cloud-watch-policy" {
#   role       = aws_iam_role.report_role.name
#   policy_arn = "arn:aws:iam::837491041518:policy/cloud-watch-policy"
# }
