/*
ec2_instances = {
  web1 = "myWebServer1",
  web2 = "myWebServer2",
  web3 = "myWebServer3"
}
*/
ec2_instances = [
  "myWebServer1-penchal",
  "myWebServer2-penchal",
  "myWebServer3-penchal"
]
 
ami_id        = "ami-06067086cf86c58e6"
instance_type = "t2.micro"