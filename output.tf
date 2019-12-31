output "public_ip" {
  value = "${aws_instance.awx-server.public_ip}"
}
