resource "aws_instance" "report-generator" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name               = "fake2bastion"
  vpc_security_group_ids = [aws_default_security_group.New_Customer_VPC_SG.id]
  subnet_id              = aws_subnet.private_1.id
  iam_instance_profile   = "scheduler-server-role"
  tags = {
    Name = "${var.CUSTOMER_NAME}-report-Prod"
  }
  user_data = file("${path.module}/script.sh")
}


resource "aws_instance" "vultara-scheduler" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name               = "fake2bastion"
  vpc_security_group_ids = [aws_default_security_group.New_Customer_VPC_SG.id]
  subnet_id              = aws_subnet.private_2.id
  iam_instance_profile   = "scheduler-server-role"
  tags = {
    Name = "${var.CUSTOMER_NAME}-scheduler-Prod"
  }
  user_data = file("${path.module}/script.sh")
}




resource "aws_instance" "bastion-host" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name               = "bastion-host-ssh"
  vpc_security_group_ids = [aws_default_security_group.New_Customer_VPC_SG.id]
  subnet_id              = aws_subnet.public_1.id
  iam_instance_profile   = "scheduler-server-role" 
  associate_public_ip_address = true
  tags = {
    Name = "${var.CUSTOMER_NAME}-bastion-host"
  }
}
