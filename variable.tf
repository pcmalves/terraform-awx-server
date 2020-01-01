variable "root_block_device" {
  default = [{
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = "true"
  }]
}