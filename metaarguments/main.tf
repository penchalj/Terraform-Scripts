terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

provider "aws" {
  alias="us"
  region = "us-east-1"
}
provider "aws" {
  alias="eu"
  region = "eu-west-1"
}

resource "aws_instance" "web_us" {
  
  for_each=var.webserver_names
  provider = aws.us
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  tags = {
    Name=each.key
  }
   provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
    inline = ["echo Hello, Terraform!"]
  }
  //lifecycle {
    //prevent_destroy = true
  //}
 
}
/*
resource "aws_instance" "web_us" {
  count         = 2
  provider = aws.us
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"

  lifecycle {
    prevent_destroy = true
  }
 
}

resource "aws_instance" "web_eu" {
  count         = 2
  provider      = aws.eu
  ami           = "ami-0049736975ba478c0"
  instance_type = "t2.micro"
  
  lifecycle {
    prevent_destroy = true
  }
 
  
}
*/
