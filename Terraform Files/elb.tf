resource "aws_security_group" "elbsg" {
  name        = "elbsg"
  description = "adding"
  vpc_id      = "${aws_vpc.lampvpc.id}"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
	ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "lampelb" {
  name               = "lampelb"
  security_groups = ["${aws_security_group.elbsg.id}"]
  subnets = ["${aws_subnet.lamppubs1.id}", "${aws_subnet.lamppubs2.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.linux1.id}","${aws_instance.linux2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "lampelb"
  }
}
resource "aws_route53_record" "alias_route53_record" {
  zone_id = "Z2PAZIKLH49M8N"
   name    = "zephyr90.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.lampelb.dns_name}"
    zone_id                = "${aws_elb.lampelb.zone_id}"
    evaluate_target_health = true
  }
}