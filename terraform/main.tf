provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

resource "aws_vpc" "main-vpc" {
  cidr_block           = var.cidr["main"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "MAIN_VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main-vpc.id
}

resource "aws_subnet" "front_subnet" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.cidr["front"]
  map_public_ip_on_launch = true
  #availability_zone       = "us-east-1a"
  depends_on = ["aws_internet_gateway.gw"]
  tags = {
    Name = "front_subnet"
  }
}

resource "aws_route_table" "front_subnet_rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "rta_front_subnet" {
  subnet_id      = aws_subnet.front_subnet.id
  route_table_id = aws_route_table.front_subnet_rt.id
}

resource "aws_security_group" "front" {
  name        = "Apache Security Group"
  description = "Allow Https port inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id
  dynamic "ingress" {
    for_each = ["443", "80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "front_acces"
  }
}

resource "aws_instance" "front" {
  ami                    = var.ami
  instance_type          = var.instance_type
  tags                   = { name = "frontend" }
  subnet_id              = aws_subnet.front_subnet.id
  vpc_security_group_ids = [aws_security_group.front.id]
  user_data              = file("install_chef-client.sh")
  key_name               = "ssh"
  provisioner "file" {
    source      = "F:/Task/demo/chef-repo"
    destination = "/home/centos/chef-repo"
    #destination = "/home/ec2-user/chef-repo"
  }
  connection {
    host = aws_instance.front.public_ip
    type = "ssh"
    user = "centos"
    #user        = "ec2-user"
    password    = ""
    private_key = "${file("ssh.pem")}"
  }
}
