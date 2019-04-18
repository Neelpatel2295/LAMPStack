resource "aws_security_group" "linux-securitygroup" {  
  name        = "linux"
  description = "Allow SSH traffic to bastion"
  vpc_id      = "${aws_vpc.lampvpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/24"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
   security_groups = ["${aws_security_group.elbsg.id}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elbsg.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 }

resource "aws_instance" "linux1" {
    ami = "ami-06397100adf427136"
    availability_zone = "us-west-1b"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.generated_key.key_name}"
    subnet_id = "${aws_subnet.lamppris1.id}"
	iam_instance_profile = "${aws_iam_instance_profile.instanceprofile.name}"

	vpc_security_group_ids = ["${aws_security_group.linux-securitygroup.id}"]
		
	depends_on = ["aws_security_group.linux-securitygroup"]
	user_data = "${file("starthttpd.sh")}"
  
    tags {
        Name = "linux1 Instance"
    }
	
}
resource "aws_instance" "linux2" {
    ami = "ami-06397100adf427136"
    availability_zone = "us-west-1c"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.generated_key.key_name}"
    subnet_id = "${aws_subnet.lamppris2.id}"
	iam_instance_profile = "${aws_iam_instance_profile.instanceprofile.name}"
    vpc_security_group_ids = ["${aws_security_group.linux-securitygroup.id}"]
		
	depends_on = ["aws_security_group.linux-securitygroup"]
	user_data = "${file("starthttpd.sh")}"


  
    tags {
        Name = "linux2 Instance"
    }

}
