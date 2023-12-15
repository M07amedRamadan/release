variable "region" {
  type = string
}

variable "cidr" {
  type = string
}

variable "public_subnet_1" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "public_subnet_2" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "private_subnet_1" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "private_subnet_2" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "CUSTOMER_NAME" {
  type = string
}

<<<<<<< HEAD
=======
variable "bastion_key" {
  type = string
}

variable "report_key" {
  type = string
}

variable "scheduler_key" {
  type = string
}
>>>>>>> origin/main
