terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/deployer-key.pub")
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ideally, replace this with your IP address, e.g., "203.0.113.0/32"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server_1" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  user_data              = <<-EOF
                            #!/bin/bash
                            yum update -y
                            yum install -y httpd
                            systemctl start httpd
                            systemctl enable httpd
                            EOF

  tags = {
    Name = "EC2 Number 1"
  }
}

resource "aws_instance" "app_server_2" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  user_data              = <<-EOF
                            #!/bin/bash
                            yum update -y
                            yum install -y httpd
                            systemctl start httpd
                            systemctl enable httpd
                            EOF

  tags = {
    Name = "EC2 Number 2"
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["subnet-058878fa62abdfa5d"] # Ensure this is a valid subnet in your VPC
  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}