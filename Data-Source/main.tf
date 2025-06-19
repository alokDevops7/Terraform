provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "Data-Source-VPC" {
  id = "vpc-0039fe15a0fdc461e" # Replace with your VPC ID
}

resource "aws_internet_gateway" "IGW-data-source" {
  vpc_id = data.aws_vpc.Data-Source-VPC.id

  tags = {
    Name = "IGW-data-source"
  }
}