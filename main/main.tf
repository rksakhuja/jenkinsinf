provider "aws" {
    region = "${var.region}"
    # access_key = "${var.aws_access_key}"
    # secret_key = "${var.aws_secret_key}"
}

module "jenkins_network" {
    source = "../modules/network"
    # vpc_id is generated when the vpc is created and we define it here to allow it to be used in another module
    vpc_id = "${module.jenkins_network.vpc_id}"
    subnet_id = "${module.jenkins_network.subnet_id}"
    cidr_block = "10.1.0.0/16"
    subnet_public = "10.1.0.32/27"
    nametag = "Jenkins - Rohit"
}
module "jenkins_master" {
    source = "../modules/jenkinsmaster"
    # here we use the vpc_id generated and passed from the jenkins_network module
    vpc_id = "${module.jenkins_network.vpc_id}"
    instance_type = "t2.micro"
    jenkins_master_name = "Jenkins Master"
    ami = "ami-0080e4c5bc078760e"
    subnet_id = "${module.jenkins_network.subnet_id}"
    eip_id = "${module.jenkins_master.eip_id}"
    # get dns name so we can output a value for the jenkins login page
    eip_dns = "${module.jenkins_master.eip_dns}"
    sgrp_id = "${module.jenkins_master.sgrp_id}"
    key_name = "${module.jenkins_master.key_name}"
}
# show user the dns address for jenkins master
output "jenkins_master_dns" {
    value = "${module.jenkins_master.eip_dns}:8080"
    depends_on = ["${module.jenkins_master}"]
}
module "jenkins_slave" {
    source = "../modules/jenkinsslave"
    vpc_id = "${module.jenkins_network.vpc_id}"
    instance_type = "t2.micro"
    jenkins_slave_name = "Jenkins Slave"
    ami = "ami-0080e4c5bc078760e"
    slaves_count = "3"
    subnet_id = "${module.jenkins_network.subnet_id}"
    sgrp_id = "${module.jenkins_master.sgrp_id}"
    # key name is passed from jenkins_master module and used here as a global.
    key_name = "${module.jenkins_master.key_name}"
}
# show user the slave IP address 
# output "jenkins_slave_dns" {
#     value = "${module.jenkins_slave.public_ip}"
#     depends_on = ["${module.jenkins_slave}"]
# }