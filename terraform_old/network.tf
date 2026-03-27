# network.tf
resource "aws_vpc" "tannaz_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tannaz-vpc"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "tannaz_igw" {
  vpc_id = aws_vpc.tannaz_vpc.id

  tags = {
    Name = "tannaz-igw"
  }
}
# Public Subnet (for frontend / bastion)
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.tannaz_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tannaz-public-subnet-a"
  }
}
# Route table for public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.tannaz_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tannaz_igw.id
  }

  tags = {
    Name = "tannaz-public-rt"
  }
}

# Associate public subnet with this route table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}
# Private Subnet (for backend + db)
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.tannaz_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "tannaz-private-subnet-b"
  }
}
