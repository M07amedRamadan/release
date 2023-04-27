resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name               = "${var.key_name}"
  vpc_security_group_ids = [aws_security_group.New_Customer_VPC_SG.id]
  subnet_id              = aws_subnet.private_1.id
  iam_instance_profile   = "scheduler-server-role"
  tags = {
    Name = "${var.CUSTOMER_NAME}-scheduler-Prod"
  }
  user_data = file("${path.module}/script.sh")
}