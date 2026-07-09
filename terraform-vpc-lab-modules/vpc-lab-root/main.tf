terraform {
  required_version = ">= 1.8.0"
}
 
provider "aws" {
  region = "us-east-1"   # or whatever region you used earlier
}
 
module "vpc" {
  source="../vpc-module"
 
  # Pass in exactly the variables your module expects
  cidr_block     = var.cidr_block
  key_pair_name  = var.key_pair_name
  vpc_name       = var.vpc_name


  # instance_type = "t3.micro"  # example override for a defaulted var
}


