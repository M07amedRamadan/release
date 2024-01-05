resource "aws_iam_role" "report_role" {
  name = "${var.CUSTOMER_NAME}_report_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:s3:::${var.CUSTOMER_NAME}-reports-bucket/*"]
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ContainerRegistry" {
  role       = aws_iam_role.report_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManaged" {
  role       = aws_iam_role.report_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "send_email_only" {
  role       = aws_iam_role.report_role.name
  policy_arn = "arn:aws:iam::837491041518:policy/send_email_only_policy"
}

resource "aws_iam_role_policy_attachment" "secret-mgr-read" {
  role       = aws_iam_role.report_role.name
  policy_arn = "arn:aws:iam::837491041518:policy/secret-mgr-read-all-secret-policy"
}

resource "aws_iam_role_policy_attachment" "mgr-assume-role" {
  role       = aws_iam_role.report_role.name
  policy_arn = "arn:aws:iam::837491041518:policy/secret-mgr-assume-role-policy"
}

resource "aws_iam_role_policy_attachment" "cloud-watch-policy" {
  role       = aws_iam_role.report_role.name
  policy_arn = "arn:aws:iam::837491041518:policy/cloud-watch-policy"
}
