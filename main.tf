
## specific the provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region =  "us-east-1"
}

#creating a VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "Deployment 5 VPC"
    }
}

# creating security group
resource "aws_security_group" "d5_sg" {
    name = "d5_sg"
    description = "tcp protocol for D5" 

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.main.id

    tags = {
        "Name" : "d5_sg"
        "Terraform" : "true"
    }
}
  
#creating a Public Subnet
resource "aws_subnet" "pubsubnet_1"{
    vpc_id =  aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "D5 Public Subnet 1"
    }
}

resource "aws_subnet" "pubsubnet_2"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "D5 Public Subnet 2"
    }
}

resource "aws_instance" "pub1" {
  ami = var.ami
  instance_type =  var.instance_type
  vpc_security_group_ids = ["${aws_security_group.d5_sg.id}"]
  subnet_id = "${aws_subnet.pubsubnet_1.id}"
  associate_public_ip_address = true

  user_data = "${file("deployjenkins.sh")}"
  tags = {
    "Name" : "d5_instance_1"
  }
}


resource "aws_instance" "pub2" {
  ami = var.ami
  instance_type =  var.instance_type
  vpc_security_group_ids = ["${aws_security_group.d5_sg.id}"]
  subnet_id = "${aws_subnet.pubsubnet_2.id}"
  associate_public_ip_address = true

  user_data = "${file("deploypython.sh")}"
  tags = {
    "Name" : "d5_instance_2"
  }
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "d5_igw"
    }
}

resource "aws_route" "routetable" {
    route_table_id = aws_vpc.main.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}


