provider "aws" {
region     = "us-west-1"
}
resource "aws_vpc" "lampvpc" {
  cidr_block       = "172.31.0.0/16"
  instance_tenancy = "default"
  tags {
    Name = "lampvpc"
  }
}
resource "aws_internet_gateway" "lampgw" {
  vpc_id = "${aws_vpc.lampvpc.id}"
  tags {
    Name = "lampgw"
  }
}
resource "aws_subnet" "lamppubs1" {
  vpc_id     = "${aws_vpc.lampvpc.id}"
  cidr_block = "172.31.0.0/24"
  availability_zone = "us-west-1b"
  tags {
    Name = "lamppubs1"
  }
}
resource "aws_subnet" "lamppubs2" {
  vpc_id     = "${aws_vpc.lampvpc.id}"
  cidr_block = "172.31.2.0/24"
  availability_zone = "us-west-1c"
  tags {
    Name = "lamppubs2"
  }
}
resource "aws_subnet" "lamppris1" {
  vpc_id     = "${aws_vpc.lampvpc.id}"
  cidr_block = "172.31.4.0/24"
  availability_zone = "us-west-1b"
  tags {
    Name = "lamppris1"
  }
}
resource "aws_subnet" "lamppris2" {
  vpc_id     = "${aws_vpc.lampvpc.id}"
  cidr_block = "172.31.8.0/24"
  availability_zone = "us-west-1c"

  tags {
    Name = "lamppris2"
  }
}
resource "aws_route_table" "lamppubrt" {
  vpc_id = "${aws_vpc.lampvpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.lampgw.id}"
  }
  tags {
    Name = "lamppubrt"
  }
}
resource "aws_route_table_association" "lamprta1" {
  subnet_id      = "${aws_subnet.lamppubs1.id}"
  route_table_id = "${aws_route_table.lamppubrt.id}"
}
resource "aws_route_table_association" "lamprta4" {
  subnet_id      = "${aws_subnet.lamppubs2.id}"
  route_table_id = "${aws_route_table.lamppubrt.id}"
}

resource "aws_route_table" "lampprirt" {
  vpc_id = "${aws_vpc.lampvpc.id}"
	route {
        cidr_block = "0.0.0.0/0"
		instance_id = "${aws_instance.nat.id}"
    }
  tags {
    Name = "lampprirt"
  }
}
resource "aws_route_table_association" "lamprta2" {
  subnet_id      = "${aws_subnet.lamppris1.id}"
  route_table_id = "${aws_route_table.lampprirt.id}"
}
resource "aws_route_table_association" "lamprta3" {
  subnet_id      = "${aws_subnet.lamppris2.id}"
  route_table_id = "${aws_route_table.lampprirt.id}"
}