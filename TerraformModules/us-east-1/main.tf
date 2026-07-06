terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specifies the version block
    }
  }
}

# The AWS Provider Block
provider "aws" {
  region = "us-east-1" # Change this to your preferred AWS region
}



module "payroll" {
  source              = "../modules/payroll"
  ami_id              = "ami-07d9b9ddc6cd8dd30" # Ensure this AMI is valid for your region
  instance_type       = "t2.micro"
  instance_name          = "Payroll-Server-Penchal"
  s3_bucket_name      = "payroll-docs-us-east-1-penchal"
  dynamodb_table_name = "PayrollDB-penchal"
}