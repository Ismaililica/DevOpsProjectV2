provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "demo-server" {
  ami           = "ami-0c7d68785ec07306c"
  instance_type = "t3.micro"
  key_name      = "dpp"

  subnet_id                   = "subnet-05540b2a592348cfc"
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.demo_sg.id]

  tags = {
    Name = "demo-server"
  }
}

resource "aws_security_group" "demo_sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = "vpc-09c02d00eeaa2c750"

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-port"
  }
}
