variable "key_pair_name" {
  description = "The name of the AWS key pair to use for SSH access"
  type        = string
  
}

variable "cidr_block" {
  description = "CIDR Block Address"
  type        = string
 
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}