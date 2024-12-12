# No change required in this file

terraform {
  backend "s3" {    
    # backend stores .tftsate file remotely                                           
  }
   required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.0"
    }
  }
  required_version = ">= 1.0"
}