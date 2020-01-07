variable "ami" {
  default = "ami-04b9e92b5572fa0d1"
}

variable "root_block_device" {
  default = [{
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = "true"
  }]
}

variable "instance_type" {
  default = "t2.medium"
}

variable "name" {
  default = "awx-server"
}
