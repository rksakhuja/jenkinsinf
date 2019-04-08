# configure vpc
resource "aws_vpc" "jenkins" {
  
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true

    tags = {

    Name = "${var.nametag}"

  }

}
#create an output for this in the outputs.tf file as we will need it for instance creation


resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.jenkins.id}"

  tags = {
    Name = "${var.nametag}"
  }
}



# resource "aws_eip" "lb" {
  #instance                  = "${aws_instance.jenkinsms.id}"
  # vpc                       = true
  #associate_with_private_ip = "${aws_instance.jenkinsms.private_ip}"
  # depends_on                = ["aws_internet_gateway.gw"]
# }
# configure subnet

resource "aws_subnet" "public" {
  vpc_id       = "${var.vpc_id}"
  cidr_block  = "${var.subnet_public}"
  tags = {
    Name = "${var.nametag}-${var.subnet_public}-Subnet"
  }
}

# configure route to internet and RTA
resource "aws_route_table" "pub" {
  vpc_id = "${aws_vpc.jenkins.id}"

  route {
    cidr_block = "0.0.0.0/0"   
    gateway_id = "${aws_internet_gateway.gw.id}"
}
 tags = {
    Name = "${var.nametag}"
  }
}
resource "aws_route_table_association" "publicRTA" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.pub.id}"
}


