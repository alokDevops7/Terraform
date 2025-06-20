resource "aws_instance" "web-1" {
  ami                         = "ami-020cba7c55df1f615"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "secops-key"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Prod-Server"
    Env        = "Prod"
    Owner      = "Alok"
    CostCenter = "ABCD"
  }
}