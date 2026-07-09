

resource "aws_instance" "ec2" {
  count      = length(var.ec2_instances)
  ami           = var.ami_id
  instance_type = var.instance_type
 
  tags = {
    Name = var.ec2_instances[count.index]
  }
  depends_on =[aws_security_group.allow_ssh]
}

resource "aws_security_group" "allow_ssh-penchal" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}