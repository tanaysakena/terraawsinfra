# Define the AWS provider and region
provider "aws" {
  region = "us-east-1" # You can change the region as needed
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet in the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = vpc-0a01a34d99d927797
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Change to your desired availability zone
  map_public_ip_on_launch = true
}

# Create a security group for the EC2 instance
resource "aws_security_group" "my_sg" {
  name_prefix = "my-sg-"
  
  // Inbound rules for SSH (port 22) and HTTP (port 80)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  vpc_id = aws_vpc.my_vpc.id
}

# Create an Ubuntu EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 LTS AMI ID (you can change this)
  instance_type = "t2.micro"             # Change the instance type as needed
  subnet_id     = aws_subnet.my_subnet.id
  key_name      = "test.pem"        # Replace with your SSH key pair
  security_groups = [aws_security_group.my_sg.id]

  tags = {
    Name = "MyUbuntuEC2"
  }
}
