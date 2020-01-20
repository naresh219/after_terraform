#### DB subnets
resource "aws_subnet" "db_subnet_1" {
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "${var.aws_db_subnet_1_cidr}"
  tags {
    Name = "WordPress subnet 1"
  }
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "${var.aws_db_subnet_2_cidr}"
  tags {
    Name = "WordPress subnet 2"
  }
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

### SECURITY GROUP 
resource "aws_security_group" "db" {
  name = "db-secgroup"
  vpc_id = "${aws_vpc.app_vpc.id}"

  # TCP access only from wp subnet and vpn
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      "${var.aws_wp_subnet_cidr}", # WP subnet
      "${var.aws_pub_subnet_1_cidr}", # Public subnet for bastion host debug
      "${var.gcp_wp_subnet}" # WP subnet on gcp across the vpn
    ]
  }
  
  # Egress to everyone
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
