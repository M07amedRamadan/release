variable "region" {
  type = string
}

variable "CUSTOMER_NAME" {
  type = string
  default = "dublication-resources"
}

variable "Application_type" {
  type = string
  default = "Vultara"
  description = "which application does the user will use, vultara or vultara and SOC"
}
