###### provision RDS
# make db subnet group 
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = ["${aws_subnet.db_subnet_1.id}", "${aws_subnet.db_subnet_2.id}"]
}

resource "aws_db_instance" "wp-db" {
  identifier = "wp-db"
  instance_class = "db.t2.micro"
  allocated_storage = 20
  engine = "mysql"
  name = "wordpress_db"
  password = "${var.aws_wp_db_password}"
  username = "${var.aws_wp_db_user}"
  engine_version = "5.7"
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
}
