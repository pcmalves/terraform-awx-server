provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-1"
}

resource "aws_vpc" "vpc-awx-server" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-1"
  }
}

resource "aws_subnet" "sb-awx-server" {
  vpc_id                  = "${aws_vpc.vpc-awx-server.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "sb-awx-server"
  }
}

data "http" "my-ip-address" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "sg_awx_server" {
  vpc_id = "${aws_vpc.vpc-awx-server.id}"

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
    Name = "sg-awx-server"
  }
}

resource "aws_internet_gateway" "igw-vpc-1" {
  vpc_id = "${aws_vpc.vpc-awx-server.id}"

  tags = {
    Name = "igw-vpc-1"
  }
}

resource "aws_route_table" "rtb-vpc-1" {
  vpc_id = "${aws_vpc.vpc-awx-server.id}"

  tags = {
    Name = "rtb-vpc-1"
  }
}

resource "aws_route" "internet-access-vpc-1" {
  route_table_id         = "${aws_route_table.rtb-vpc-1.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw-vpc-1.id}"
}

resource "aws_route_table_association" "vpc-association" {
  subnet_id      = "${aws_subnet.sb-awx-server.id}"
  route_table_id = "${aws_route_table.rtb-vpc-1.id}"
}

resource "aws_key_pair" "access-key-instance" {
  key_name   = "awx-access-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8v2gGEcmVnWUTCX+akw34RYJFglXnLIAsA2txIZ95sd0mHkbnw04sQo/Hu2f5Yl5uXBpjLued7jVzouzkN1Jf52tAk8qJMXLSRLdhUVEoPU4dTuP6r1WlKwiij7tWSoI8V+G3QdRYLRua7cpmzik3lw4qtP+COw7fO3pT9kI68JmeVLs+mAhoZ1F+4+O1RfgsnpIczhEH2u01jRAkQ/z5v5/7upIt0a0ZSao1t8uBUH7dHrSZKbrklWONlAdR3HdzH/Y2sw1ZEOAgQ8uSoDPgiHMWYue2yyjKNn2JX07Ac0JES7LhC4QHt+28i7KIky/0EQuB4KVrleVboikhr1jj paulo@qbnotebook"
}

resource "aws_instance" "awx-server" {
  instance_type          = "t2.medium"
  ami                    = "ami-04b9e92b5572fa0d1"
  key_name               = "${aws_key_pair.access-key-instance.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_awx_server.id}"]
  subnet_id              = "${aws_subnet.sb-awx-server.id}"
  root_block_device      = "${var.root_block_device}"
  user_data              = "${data.template_file.awx-server-userdata.rendered}"

  tags = {
    Name = "awx-server"
  }
}

data "template_file" "awx-server-userdata" {
  template = "${file("./script/awx-server-userdata.sh")}"

  vars {
    hostname = "awx-server"
  }
}
