#### EC2 INSTANCES #################

# bastion ############################
resource "aws_instance" "bastion" {
  ami = "${data.aws_ami.ubuntu.id}"
  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}"
  ]
  instance_type = "${var.aws_instance_type}"
  subnet_id = "${aws_subnet.pub_subnet_1.id}"

  key_name = "${aws_key_pair.demo_keys.key_name}"
  tags {
    Name = "Bastion"
    SELECTOR = "bastion"
  }
}

resource "aws_eip" "bastion_eip" {
  depends_on = ["aws_internet_gateway.app_igw", "aws_vpc_dhcp_options_association.dns_resolver"]
}

resource "aws_eip_association" "bastion_eip_assoc" {
  instance_id = "${aws_instance.bastion.id}"
  allocation_id = "${aws_eip.bastion_eip.id}"
}
