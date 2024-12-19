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

locals {
  resource_names = var.Application_type == "Vultara" ? ["${var.CUSTOMER_NAME}"] : var.Application_type == "SOC" ? ["${var.CUSTOMER_NAME}.soc"] : [["${var.CUSTOMER_NAME}"],"${var.CUSTOMER_NAME}.soc"]
}