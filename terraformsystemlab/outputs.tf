# 6. Terraform Outputs
output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.my_ec2.public_ip
}

output "instance_url" {
  description = "Clickable URL to view your web page"
  value       = "http://${aws_instance.my_ec2.public_ip}"
}

output "s3_website_url" {
  description = "The URL of the static website hosted on S3"
  value       = "http://${aws_s3_bucket_website_configuration.web_config.website_endpoint}"
}