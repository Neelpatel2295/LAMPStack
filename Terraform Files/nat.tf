resource "aws_security_group" "nat-securitygroup" {  
  name        = "nat"
  description = "Allow traffic to pass from the private subnet to the internet"
  vpc_id      = "${aws_vpc.lampvpc.id}"
 

  ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["172.31.8.0/24","172.31.4.0/24"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["172.31.8.0/24","172.31.4.0/24"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["172.31.0.0/16"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "NAT securitygroup"
    }


 }
resource "aws_key_pair" "generated_key" {
  key_name   = "lampkey1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQBOEyKSvFNhy2CtP+Gop+ZcLZ1OyqOQLOGAAkcKL+diLYyE3iM/J+3Crkdv5HJsE+Kb2KhZDzmwuwnMDScBLHSjvanQBIf6rX6k65qHjrcQPY1puR8Ca861ePM8T1geg/mNGRmdTZF6OTFcTCYJYfp71sEdARywKqw1j953juEIjXuRMANieE2Mq9QIONnTCdWN6X8PKee6J5LBNKaDq9/J5nwKNhvMnd1komioXaTgYJLJ4zDXZbHFFY4PkH665GmjjcSIAgfdzeuoETqnMD7fmgAqy4DMPVF+NOfhdyax/RCEIA/+fKyFBSCRGEf4CXHolLsGV8jzh/qJOMxNlAS5 rsa-key-20190324"
}
resource "aws_instance" "nat" {
    ami = "ami-004b0f60"
    availability_zone = "us-west-1b"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.generated_key.key_name}"
    subnet_id = "${aws_subnet.lamppubs1.id}"
    associate_public_ip_address = true
	vpc_security_group_ids = ["${aws_security_group.nat-securitygroup.id}"]
	source_dest_check = false
	depends_on = ["aws_security_group.nat-securitygroup"]
    tags {
        Name = "Nat Instance"
    }
}

resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}
