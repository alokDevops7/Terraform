data "aws_vpc" "terraform-aws-testing" {
  id = "vpc-0d3c4863b8bce1bb4" # Replace with your VPC ID
}

data "aws_subnet" "Terraform_Public_Subnet1-testing" {
  id = "subnet-04afa44daa77861b7" # Replace with your VPC ID
}

data "aws_security_group" "allow_all" {
  id = "sg-03c6efc147ec545e9" # Replace with your VPC ID
}