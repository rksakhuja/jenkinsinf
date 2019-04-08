variable "vpc_id" {}
variable "instance_type" {}
variable "jenkins_slave_name" {}
variable "ami" {}
variable "slaves_count" {}
variable "subnet_id" {}
variable "sgrp_id" {}
variable "key_name" {}
variable "public_ip" {}  
# variable "azs" {
#     type = "list"
#     default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
# }