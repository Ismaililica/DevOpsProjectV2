provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "demo-server" {
  ami           = "ami-0fa91bc90632c73c9"
  instance_type = "t3.micro"
  key_name      = "dpp"
  
  subnet_id                   = aws_subnet.dpp_public_subnet-01.id

  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  
  tags = {
    Name = "demo-server"
  }
}

resource "aws_security_group" "demo_sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.dpp_vpc.id

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

resource "aws_vpc" "dpp_vpc" {
  cidr_block = "10.1.0.0/16"
  tags ={
    Name= "dpp-vpc"
  }
}


resource "aws_subnet" "dpp_public_subnet-01" {
  vpc_id= aws_vpc.dpp_vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-north-1a"
  tags = {
    Name= "dpp_public_subnet-01"
  }
  
}

resource "aws_subnet" "dpp_public_subnet-02" {
  vpc_id= aws_vpc.dpp_vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-north-1b"
  tags = {
    Name= "dpp_public_subnet-02"
  }
  
}

resource "aws_internet_gateway" "dpp_igw" {
  vpc_id= aws_vpc.dpp_vpc.id
  tags = {
    Name= "dpp_igw"
  }

  
}

resource "aws_route_table" "dpp_public_route_table" {
  vpc_id = aws_vpc.dpp_vpc.id
  route  {
    cidr_block= "0.0.0.0/0"
    gateway_id= aws_internet_gateway.dpp_igw.id
  }
  
}

resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
  subnet_id = aws_subnet.dpp_public_subnet-01.id
  route_table_id = aws_route_table.dpp_public_route_table.id
  
}

resource "aws_route_table_association" "dpp-rta-public-subnet-02" {
  subnet_id = aws_subnet.dpp_public_subnet-02.id
  route_table_id = aws_route_table.dpp_public_route_table.id
  
}