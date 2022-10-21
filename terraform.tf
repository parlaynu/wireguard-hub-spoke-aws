terraform {  
  required_version = ">= 1.3.2"
  required_providers {
    aws = {      
      source  = "hashicorp/aws"      
      version = "~> 4.35"
    }
    wireguard = {
      source = "ojford/wireguard"
      version = "0.2.1+1"
    }
  }
}


provider "aws" {  
  profile = var.aws_profile
  region = var.aws_region
}

provider "wireguard" {}

