
# pull ssh key from machine and assign it to "this_key this is the only time its generated, exported in outputs"
resource "aws_key_pair" "this_key" {
  key_name   = "jkmaster_key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}


# configure elastic ip i dont need to worry about dependencies here as i know the network module is called before this? 
# nb: the network module should be called before this! 

resource "aws_eip" "lb" {
  instance                  = "${aws_instance.jenkinsms.id}"
  vpc                       = true
  #attach to jenkins master here
  associate_with_private_ip = "${aws_instance.jenkinsms.private_ip}"
  #depends_on                = ["aws_internet_gateway.gw"]
}


# jenkins master server using variables passewd from network module; this is defined in main.tf here we can refer to them as
# local variables (?)
resource "aws_instance" "jenkinsms" {
  #count                         = "${var.slaves_count}"
  ami                           = "${var.ami}"
  instance_type                 = "${var.instance_type}"
  # using the resource varible here as the resouce is created in this module - later will use the passed key using "module."
  key_name                      = "${aws_key_pair.this_key.key_name}"
  vpc_security_group_ids        = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address   = false
  subnet_id                     = "${var.subnet_id}"

  # user_data =  <<-EOF
  #               #!/bin/bash
  #               sudo yum update -y
  #               sudo yum remove -y java
  #               sudo yum install -y java-1.8.0-openjdk
  #               sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  #               sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  #               sudo yum install jenkins -y
  #               sudo service jenkins start
  #               EOF
  tags = {
    Name = "${var.jenkins_master_name}"
  }
}


# create sg to allow all for now...
  resource "aws_security_group" "allow_all" {
  name = "allow_all"
  vpc_id = "${var.vpc_id}"

  # SSH access
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}