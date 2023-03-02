variable "myregion" {
  type = string
}

variable "accesskey" {
  type = string
}

variable "secretkey" {
  type = string
}

variable "cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
}

variable "tenancy" {
  type = string
}

variable "ports" {
  type = list(number)
}