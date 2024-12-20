locals {

    resources= var.Application_type == "Vultara" ? ["${var.CUSTOMER_NAME}"] : var.Application_type == "SOC" ? ["${var.CUSTOMER_NAME}.soc"] : ["${var.CUSTOMER_NAME}","${var.CUSTOMER_NAME}.soc"]
    
    certificationArn = {
      "${var.CUSTOMER_NAME}" = "arn:aws:acm:us-east-1:837491041518:certificate/74e193b1-9bae-49cd-af83-bc3f05ccbba1"
      "${var.CUSTOMER_NAME}.soc" = "arn:aws:acm:us-east-1:837491041518:certificate/dc1be4c8-8eb8-4d9f-9631-3d7dab4838a9"
    }
    
    countNum= {
       "${var.CUSTOMER_NAME}" = "0"
       "${var.CUSTOMER_NAME}.soc" = "1"
    }

 }
