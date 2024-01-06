# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet inside the VPC
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Replace with your preferred availability zone
  map_public_ip_on_launch = true
}

# Create a security group for the Lambda function
resource "aws_security_group" "lambda_sg" {
  vpc_id = aws_vpc.example_vpc.id
}