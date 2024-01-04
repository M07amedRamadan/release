resource "aws_instance" "report-generator" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name               = "vultara-report-server-KP"
  vpc_security_group_ids = [aws_security_group.reportGenerator_SG.id]
  subnet_id              = aws_subnet.private_1.id
  iam_instance_profile = aws_iam_role.report_role.name
  tags = {
    Name = "${var.CUSTOMER_NAME}-report-Prod"
  }
  user_data = file("${path.module}/script.sh")
}


resource "aws_instance" "vultara-scheduler" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name               = "vultara-trial-scheduler-KP"
  vpc_security_group_ids = [aws_security_group.schedulerServer_SG.id]
  subnet_id              = aws_subnet.private_2.id
  #iam_instance_profile   = scheduler-server-role
  iam_instance_profile = aws_iam_role.report_role.name
  tags = {
    Name = "${var.CUSTOMER_NAME}-scheduler-Prod"
  }
  user_data = file("${path.module}/script.sh")
}
