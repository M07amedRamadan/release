provider "aws" {
  alias  = "key"
  region = "us-east-1"
 
}

resource "aws_instance" "report_generator" {
  ami                    = var.ami  
  instance_type          = var.instance_type
  #key_name              = "vultara-report-server-KP" #create this key in the NewCustomer region
  key_name               = data.aws_key_pair.report_key.key_name  #for the key in a different region but not worked yet 
  vpc_security_group_ids = [aws_security_group.reportGenerator_SG.id]
  subnet_id              = aws_subnet.private_1.id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

tags = {
  Name = "${var.CUSTOMER_NAME}-report-Prod"
  }
  user_data = file("${path.module}/report_script.sh")
}

resource "aws_instance" "vultara_scheduler" {
  ami                    = var.ami
  instance_type          = var.instance_type
  #key_name              = "vultara-trial-scheduler-KPP" #create this key in the NewCustomer region
  key_name               = data.aws_key_pair.scheduler_key.key_name  #for the key in a different region but not worked yet 
  vpc_security_group_ids = [aws_security_group.schedulerServer_SG.id]
  subnet_id              = aws_subnet.private_2.id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  tags = {
  Name = "${var.CUSTOMER_NAME}-scheduler-Prod"
  }
  user_data = file("${path.module}/schedular_script.sh")
}

# Obtain the report key from an existing key pair in us-east-1
data "aws_key_pair" "report_key" {
  provider = aws.key
  key_name = "vultara-report-server-KP"
} 

# Obtain the scheduler key from an existing key pair in us-east-1
data "aws_key_pair" "scheduler_key" {
  provider = aws.key
  key_name = "vultara-trial-scheduler-KP"
}
