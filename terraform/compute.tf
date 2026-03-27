data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Frontend (Vote + Result) - public
resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "tannaz-key-new"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  tags = {
    Name = "tannaz-frontend"
  }
}

# Backend (Redis + Worker) - private
resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "tannaz-key-new"
  subnet_id              = aws_subnet.private_subnet_b.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  tags = {
    Name = "tannaz-backend"
  }
}

# Database (Postgres) - private
resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "tannaz-key-new"
  subnet_id              = aws_subnet.private_subnet_c.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "tannaz-db"
  }
}
