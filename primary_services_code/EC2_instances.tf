resource "aws_instance" "report_generator" {
  ami                    = var.ami  
  instance_type          =  var.instance_type
  key_name               = "vultara-report-server-KP"
  public_key = tls_private_key.report_generator.public_key_openssh
  vpc_security_group_ids = [aws_security_group.reportGenerator_SG.id]
  subnet_id              = aws_subnet.private_1.id
  iam_instance_profile   = "aws_iam_role.report_role.name"
tags = {
    Name = "${var.CUSTOMER_NAME}-report-Prod"
  }
  user_data = file("${path.module}/script.sh")
}

resource "aws_instance" "vultara_scheduler" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name               = "vultara-trial-scheduler-KP"
 public_key = tls_private_key.vultara_scheduler.public_key_openssh
  vpc_security_group_ids = [aws_security_group.schedulerServer_SG.id]
  subnet_id              = aws_subnet.private_2.id
  iam_instance_profile   = "scheduler-server-role"
  tags = {
  Name = "${var.CUSTOMER_NAME}-scheduler-Prod"
  }
  user_data = file("${path.module}/script.sh")
}

resource "tls_private_key" "report_generator" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "tls_private_key" "vultara_scheduler" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
output "key_pair_name" {
  value = aws_key_pair.report_generator.key_name
}

output "private_key_pem" {
  value = tls_private_key.report_generator.private_key_pem
}
output "key_pair_name" {
  value = aws_key_pair.vultara_scheduler.key_name
}

output "private_key_pem" {
  value = tls_private_key.vultara_scheduler.private_key_pem
}
