terraform {
  backend "s3" {
    bucket = "awsbucket0910"
    key    = "misc/prometheus/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "centos-8" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
}

resource "aws_instance" "prometheus" {
  ami           = data.aws_ami.centos-8.image_id
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-01d072d60ba28281d"]

  tags = {
    Name = "prometheus-server"
  }
}

resource "aws_route53_record" "prometheus" {
  zone_id = "Z0989333373BZR91I0C0P"
  name    = "prometheus"
  type    = "A"
  ttl     = 300
  records = [aws_instance.prometheus.private_ip]
}

resource "aws_route53_record" "prometheus-public" {
  zone_id = "Z0989333373BZR91I0C0P"
  name    = "prometheus-public"
  type    = "A"
  ttl     = 300
  records = [aws_instance.prometheus.public_ip]
}