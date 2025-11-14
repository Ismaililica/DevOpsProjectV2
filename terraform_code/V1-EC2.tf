provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-0c7d68785ec07306c"
    instance_type= "t3.micro"
    key_name= "dpp"

    subnet_id                   = "subnet-05540b2a592348cfc"
    associate_public_ip_address = true
  
}