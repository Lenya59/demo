provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

resource "aws_instance" "front" {
  ami                    = var.ami
  instance_type          = var.instance_type
  tags                   = { name = "frontend" }
  subnet_id              = aws_subnet.front_subnet.id
  vpc_security_group_ids = [aws_security_group.front.id]
  user_data              = file("install_httpd.sh") # pedal new script for chef client and filebeat
  key_name               = "ssh"
}

resource "aws_vpc" "main-vpc" {
  cidr_block           = var.cidr["main"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "MAIN_VPC"
  }
}

resource "aws_subnet" "front_subnet" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.cidr["front"]
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"
  depends_on              = ["aws_internet_gateway.gw"]

  tags = {
    Name = "front_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main-vpc.id
}

# resource "aws_eip" "nat" {
#   instance   = aws_instance.front.id
#   vpc        = true
#   depends_on = ["aws_internet_gateway.gw"]
# }

resource "aws_security_group" "front" {
  name        = "Apache Security Group"
  description = "Allow Https port inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id #будем цеплять впс
  dynamic "ingress" {
    for_each = ["443", "80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress { # Входящий
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Любой протокол ТСР и UDP
    cidr_blocks = ["0.0.0.0/0"] # Разрешаем ходить с инета
  }
  tags = {
    Name = "front_acces"
  }
}
