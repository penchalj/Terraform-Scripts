# providers.tf
terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "my-access-key" # Your full Access Key ID
  secret_key = "my secret access key"  # Your full Secret Access Key
}

locals {
  student_name = "Penchal" # <-- Replace with your actual name
}

# Lookup the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# Create Security Group
resource "aws_security_group" "allow_web_ssh" {
  name        = "allow_web_ssh_lab-penchal"
  description = "Allow HTTP and SSH traffic for lab environment"

  # Inbound HTTP Traffic
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound SSH Traffic
  ingress {
    description = "SSH from anywhere (Lab Only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic (Allow all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "penchal-lab-security-group"
  }
}


# Create the EC2 Instance
resource "aws_instance" "my_ec2" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_web_ssh.id] # Attaches the security group

  # Reads the external shell script and passes the local variable into it
  user_data = templatefile("${path.module}/userdata.sh", {
    student_name = local.student_name
  })

  tags = {
    Name = "Penchal-Systemdesign-Instance"
  }
}

# 1. Create the S3 Bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket        = "lab-website-${lower(local.student_name)}"
  force_destroy = true # Allows terraform destroy to succeed even if the bucket has files
}

# 2. Configure Static Website Hosting
resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.web_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# 3. Disable Public Access Blocks (Allows public policies)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.web_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Attach Public Read Policy (Depends on Public Access Block being removed)
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.web_bucket.id

  # Explicitly wait for the public access block to be relaxed
  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.web_bucket.arn}/*"
      }
    ]
  })
}

# 5. Upload index.html using Terraform
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.web_bucket.id
  key          = "index.html"
  content      = "<h1>Hello from S3 Website created by ${local.student_name}!</h1>"
  content_type = "text/html" # Critical so the browser renders it instead of downloading it
}
