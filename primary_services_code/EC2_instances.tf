provider "aws" {
  alias  = "key"
  region = "us-east-1"
 
}

resource "aws_instance" "report_generator" {
  ami                    = var.ami  
  instance_type          = var.instance_type
  key_name               = aws_key_pair.report_key.key_name
  vpc_security_group_ids = [aws_security_group.reportGenerator_SG.id]
  subnet_id              = aws_subnet.private_1.id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

tags = {
  Name = "${var.CUSTOMER_NAME}-report-Prod"
  }
  user_data = file("${path.module}/script.sh")
}

resource "aws_instance" "vultara_scheduler" {
  ami                    = var.ami
  instance_type          = var.instance_type
 # key_name               = data.aws_key_pair.scheduler_key.key_name
  vpc_security_group_ids = [aws_security_group.schedulerServer_SG.id]
  subnet_id              = aws_subnet.private_2.id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  tags = {
  Name = "${var.CUSTOMER_NAME}-scheduler-Prod"
  }
  user_data = file("${path.module}/script.sh")
}


# Obtain the public key from an existing key pair in us-east-1
data "aws_key_pair" "scheduler_key" {
  provider = aws.key
  key_name = "vultara-trial-scheduler-KP"
}
# Obtain the public key from an existing key pair in us-east-1
data "aws_key_pair" "report_key" {
  provider = aws.key
  key_name = "vultara-report-server-KP"
}
# Create a new key pair in the destination region using the public key from the source region
resource "aws_key_pair" "report_key" {
  key_name   = "new_key_name"
  public_key = data.aws_key_pair.report_key.public_key
}

output "report_key" {
value = data.aws_key_pair.report_key.id
}

output "scheduler_key" {
value = data.aws_key_pair.scheduler_key.id
}

