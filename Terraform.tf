provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "Hack-a-thon_server" {
    ami = "ami-0f5ee92e2d63afc18"
    key_name = "Linuxkey"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a" 
    subnet_id = aws_subnet.Hack-a-thon_subnet.id
    vpc_security_group_ids = [aws_security_group.Hack-a-thon_sg.id]
}
// creat aws_vpc
resource "aws_vpc" "Hack-a-thon_vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "Hack-a-thon_subnet"{
    vpc_id = aws_vpc.Hack-a-thon_vpc.id
    cidr_block = "10.0.0.0/16"
    availability_zone = "ap-south-1a"

    tags = {
        name = "Hack-a-thon"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Hack-a-thon_vpc.id

  tags = {
    Name = "Hack-a-thon_igw"
  }
}

resource "aws_route_table" "HAT_rt" {
  vpc_id = aws_vpc.Hack-a-thon_vpc.id

  route {
    cidr_block = "0.0.0.0/20"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Hack-a-thon_rt"
  }
}

resource "aws_route_table_association" "Hack-a-thon_rtassociation" {
  subnet_id      = aws_subnet.Hack-a-thon_subnet.id
  route_table_id = aws_route_table.HAT_rt.id
}

resource "aws_security_group" "Hack-a-thon_sg" {
  name        = "Hack-a-thon_sg"
  vpc_id      = aws_vpc.Hack-a-thon_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [0.0.0.0/0]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
