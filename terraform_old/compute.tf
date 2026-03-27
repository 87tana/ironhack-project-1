# Get latest Ubuntu 22.04 AMI dynamically
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
# Frontend EC2 Instance
resource "aws_instance" "tannaz_frontend" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  key_name ="tannaz-key-project"

  tags = {
    Name = "tannaz-frontend"
  }
}

# Backend EC2 Instance (redis + worker)
resource "aws_instance" "tannaz_backend" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_b.id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name ="tannaz-key-project"

  tags = {
    Name = "tannaz-backend"
  }
}
# Database EC2 Instance (PostgreSQL)
resource "aws_instance" "tannaz_db" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_b.id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name ="tannaz-key-project"

  tags = {
    Name = "tannaz-db"
  }
}
