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

variable "CUSTOMER_NAME" {
  type = string
}

variable "public_key" {
  type = string
}

variable "private_key" {
  type = string
}

