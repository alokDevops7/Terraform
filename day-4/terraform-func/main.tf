#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "alokdevopss3bucket"
    key    = "terraform-func-Infra.tfstate"
    region = "us-east-1"
  }
}

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.vpc_name}"
    Owner       = local.Owner
    TeamDL      = local.TeamDL
    CostCenter  = local.CostCenter
    environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name        = "${var.vpc_name}-IGW"
    Owner       = local.Owner
    TeamDL      = local.TeamDL
    CostCenter  = local.CostCenter
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "public-subnet" {
  count             = 3
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.public_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-public-${count.index + 1}"
    Owner       = local.Owner
    TeamDL      = local.TeamDL
    CostCenter  = local.CostCenter
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "private-subnet" {
  count             = 3
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.private_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-private-${count.index + 1}"
    Owner       = local.Owner
    TeamDL      = local.TeamDL
    CostCenter  = local.CostCenter
    environment = "${var.environment}"
  }
}



resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name        = "${var.vpc_name}-public-rt"
    Owner       = local.Owner
    TeamDL      = local.TeamDL
    CostCenter  = local.CostCenter
    environment = "${var.environment}"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name        = "${var.vpc_name}-private-rt"
    Owner       = local.Owner
    TeamDL      = local.TeamDL
    CostCenter  = local.CostCenter
    environment = "${var.environment}"
  }
}


resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
