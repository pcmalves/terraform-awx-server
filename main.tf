provider "aws" {
  region = "us-east-1"
}

module "vpc-main" {
  source                  = "git::https://github.com/pcmalves/tf-module-network.git"
  availability_zone       = "${var.availability_zone}"
  destination_cidr_block  = "${var.destination_cidr_block}"
  enable_dns_hostnames    = "${var.enable_dns_hostnames}"
  enable_dns_support      = "${var.enable_dns_support}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  subnet_cidr_block       = "${var.subnet_cidr}"
  vpc_cidr_block          = "${var.vpc_cidr_block}"
  tag_name                = "${var.name}"
}

module "instance" {
  source                 = "git::https://github.com/pcmalves/tf-module-instance.git"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  name                   = "${var.name_instance}"
  root_block_device      = "${var.root_block_device}"
  subnet_id              = "${module.vpc-main.subnet_id}"
  user_data              = "${data.template_file.awx-server-userdata.rendered}"
  vpc_security_group_ids = "${aws_security_group.sg_awx_server.id}"
}

data "template_file" "awx-server-userdata" {
  template = "${file("./script/awx-server-userdata.sh")}"

  vars {
    hostname = "${var.name}"
  }
}

data "http" "my-ip-address" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "sg_awx_server" {
  vpc_id = "${module.vpc-main.vpc_id}"

  ingress {
    description = "ssh access to my ip"
    cidr_blocks = ["${chomp(data.http.my-ip-address.body)}/32"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    description = "http access for everyone"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "sg-${var.name}"
  }
}
