
resource "aws_vpc" "database_vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "database_subnet_1" {
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1b"
  vpc_id = "${aws_vpc.database_vpc.id}"
  tags {
    Name = "database_subnet_primary"
  }
}

resource "aws_subnet" "database_subnet_2" {
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"
  vpc_id = "${aws_vpc.database_vpc.id}"
  tags {
    Name = "database_subnet_secondary"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.database_subnet_1.id}", "${aws_subnet.database_subnet_2.id}"]
  tags {
    Name = "DB subnet group"
  }
}


resource "aws_security_group" "database_security" {
  name = "database_security"
  description = "DevOps Masterclass Database port openings"
  vpc_id = "${aws_vpc.database_vpc.id}"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16", "10.1.0.0/16"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_internet_gateway" "database_igw" {
  vpc_id = "${aws_vpc.database_vpc.id}"
}

resource "aws_route_table" "database_routing" {
  vpc_id = "${aws_vpc.database_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.database_igw.id}"
  }
}

resource "aws_main_route_table_association" "database_routing_a" {
  vpc_id = "${aws_vpc.database_vpc.id}"
  route_table_id = "${aws_route_table.database_routing.id}"
}

