variable "key_pair_name" {
  description = "The name of the AWS key pair to use for SSH access"
  type        = string
}

variable "cidr_block" {
  description = "CIDR Block Address"
  type        = string
  default     = "20.0.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "MyVPC"
}

variable "igw_name" {
  description = "The name of IGW"
  type        = string
  default     = "VPC-IGW"
}

variable "public_rt_name" {
  description = "Public route name"
  type        = string
  default     = "PB_RT"
}


variable "aws_instance_name" {
  description = "The name of aws_instance"
  type        = string
  default     = "EC2-VPC"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}