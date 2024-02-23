terraform {
 required_providers {
 aws = {
 source = "hashicorp/aws"
 version = "~> 4.16"
 }
 }
 required_version = ">= 1.2.0"
}
provider "aws" {
 region = "us-east-1"
}
resource "aws_instance" "app_server_1" {
 ami = "ami-0440d3b780d96b29d"
 instance_type = "t2.micro"
 tags = {
 Name = "EC2 Number 1"
 }
}
resource "aws_instance" "app_server_2" {
 ami = "ami-0440d3b780d96b29d"
 instance_type = "t2.micro"
 tags = {
 Name = "EC2 Number 2"
 }
}
resource "aws_lb" "test" {
 name = "test-lb-tf"
 internal = false
 load_balancer_type = "network"
 subnets = ["subnet-0e7e7de3f9d002e80"]
 enable_deletion_protection = true
 tags = {
 Environment = "production"
 }
}