
resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "devops_subnet" {
  cidr_block = "${aws_vpc.devops_vpc.cidr_block}"
  map_public_ip_on_launch = "true"
  vpc_id = "${aws_vpc.devops_vpc.id}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.devops_vpc.id}"
}

resource "aws_security_group" "devops_security" {
  name = "devops_security"
  description = "DevOps Masterclass port openings"
  vpc_id = "${aws_vpc.devops_vpc.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8001
    to_port = 8099
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5985
    to_port = 5986
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5601
    to_port = 5601
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 6782
    to_port = 6782
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 2375
    to_port = 2375
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3389 
    to_port = 3389 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 2377 
    to_port = 2377 
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port = 7946
    to_port = 7946 
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port = 7946
    to_port = 7946 
    protocol = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port = 4789 
    to_port = 4789 
    protocol = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "devops_igw" {
  vpc_id = "${aws_vpc.devops_vpc.id}"
}

resource "aws_route_table" "devops_routing" {
  vpc_id = "${aws_vpc.devops_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.devops_igw.id}"
  }
}

resource "aws_main_route_table_association" "devops_routing_a" {
  vpc_id = "${aws_vpc.devops_vpc.id}"
  route_table_id = "${aws_route_table.devops_routing.id}"
}

