output "us_web_server_ids_list" {
  value = [ for instance in aws_instance.web_us : instance.id ]
}