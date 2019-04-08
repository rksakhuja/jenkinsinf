#ask about the correct way to manage keys, i am making the same key every time this module is called but its the same key...

resource "aws_instance" "jenkinsslave" {
    count                         = "${var.slaves_count}"
    ami                           = "${var.ami}"
    instance_type                 = "${var.instance_type}"
    # here i have used the key from jenkins_master module (defined in main.tf)
    key_name                      = "${var.key_name}"
    vpc_security_group_ids        = ["${var.sgrp_id}"]
    associate_public_ip_address   = true
    subnet_id                     = "${var.subnet_id}"
    tags = {
        Name = "${var.jenkins_slave_name}-${count.index+1}"
  }
}