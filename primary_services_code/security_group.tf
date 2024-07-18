# No change required in this file

resource "aws_default_security_group" "New_Customer_VPC_SG" {
  vpc_id      = aws_vpc.New_Customer_VPC.id 

  ingress {
    from_port   = 27000
    to_port     = 28000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.CUSTOMER_NAME}-Prod-SG"
  }
}


resource "aws_security_group" "reportGenerator_SG" {
  name        = "${var.CUSTOMER_NAME}-reportGenerator-SG"
  description = "security group for New Customer production environment lambda"
  vpc_id      = aws_vpc.New_Customer_VPC.id 

  ingress {
    from_port   = 27000
    to_port     = 28000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Report generator docker port"
    from_port        = 4202
    to_port          = 4202
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.CUSTOMER_NAME}-reportGenerator-Prod-SG"
  }
}


resource "aws_security_group" "schedulerServer_SG" {
  name        = "${var.CUSTOMER_NAME}-schedulerServer-SG"
  description = "security group for New Customer production environment lambda"
  vpc_id      = aws_vpc.New_Customer_VPC.id 

  ingress {
    from_port   = 27000
    to_port     = 28000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "schedulerServer docker port"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.CUSTOMER_NAME}-schedulerServer-Prod-SG"
  }
}
