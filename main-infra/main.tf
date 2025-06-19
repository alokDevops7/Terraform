provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web-1" {
  #ami = "${data.aws_ami.my_ami.id}"
  ami                         = "ami-020cba7c55df1f615"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "us-east-1a"
  subnet_id                   = data.aws_subnet.Terraform_Public_Subnet1-testing.id
  vpc_security_group_ids      = ["${data.aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-1"
    Env        = "Prod"
    Owner      = "Alok"
    CostCenter = "ABCD"
  }
  #     user_data = <<- EOF
  #     #!/bin/bash
  #     	sudo apt-get update
  #     	sudo apt-get install -y nginx
  #     	echo "<h1>${var.env}-Server-1</h1>" | sudo tee /var/www/html/index.html
  #     	sudo systemctl start nginx
  #     	sudo systemctl enable nginx
  #     EOF

}

terraform {
  backend "s3" {
    bucket = "alokdevopss3bucket"
    key    = "Current-Infra.tfstate"
    region = "us-east-1"
  }
}