variable "root_block_device" {
  default = [{
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = "true"
  }]
}

variable "access_key" {}

variable "secret_key" {}
