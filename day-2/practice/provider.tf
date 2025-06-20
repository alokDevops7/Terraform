provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "alokdevopss3bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}