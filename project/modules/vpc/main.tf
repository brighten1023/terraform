# file modules/vpc/main.tf
/*
#US-east-1a AZ data source
data "aws_availability_zones" "us-east-1a" {
  state = "avaiable"
}

#US-east-1b AZ data source
data "aws_availability_zones" "us-east-1b" {
  state = "avaiable"
}
*/

#Create VPC-Shared VPC
resource "aws_vpc" "VPC-Shared" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { Name = "VPC-Shared" }
}

#Create VPC-Dev VPC
/*
resource "aws_vpc" "VPC-Dev" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { Name = "VPC-Dev" }
}
*/
#Create public subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.VPC-Shared.id
  count = var.counter
  availability_zone = var.availability_zones[count.index]
  cidr_block = var.public_cidrs[count.index]
  tags = merge(
    var.default_tags,
    {
        Name = "Public_SN${count.index + 1}"
    }
  )
}

#Create private subnet
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.VPC-Shared.id
  count = var.counter
  availability_zone = var.availability_zones[count.index]
  cidr_block = var.public_cidrs[count.index]
  tags = merge(
    var.default_tags,
    {
        Name = "Private_SN${count.index + 1}"
    }
  )
}

#Create shared internet gateway
resource "aws_internet_gateway" "shared-igw" {
  vpc_id = aws_vpc.VPC_Shared.id
  tags = merge(
    var.default_tags,
    {
        Name = "IGW-Shared"
    }
  )
}

#Create shared EIP
resource "aws_eip" "shared-nat-eip" {
  vpc = true
}

#Create shared NAT GW
resource "aws_nat_gateway" "shared-nat" {
  allocation_id = aws_eip.shared-nat-eip.id
  subnet_id = aws_subnet.public[0].index
  tags = merge(
    var.default_tags,
    {
        Name = "SHARED-NAT-GW"
    }
  )
  depends_on = [ aws_internet_gateway.shared-igw ]
}

#Create Public Route Tables in Shared VPC
resource "aws_route_table" "shared-rt-public" {
  vpc_id = aws_vpc.VPC-Shared.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shared-igw.id
  }
  tags = merge(
    var.default_tags,
    {
        Name = "Shared-Public-RT"
    }
  )
}

#Create Private Route Tables in Shared VPC
resource "aws_route_table" "shared-rt-private" {
  vpc_id = aws_vpc.VPC-Shared.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.shared-nat.id
  }
  tags = merge(
    var.default_tags,
    {
        Name = "Shared-private-RT"
    }
  )
}

#Create Route Table Association
resource "aws_route_table_association" "shared-association-pub" {
  count = var.counter
  subnet_id = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.shared-rt-public.id
}

resource "aws_route_table_association" "shared-association-pr" {
  count = var.counter
  subnet_id = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.shared-rt-private.id
}

#Security group for Shared-Bastion
resource "aws_security_group" "shared-bastion-sg" {
  name = "shared-bastion-sg"
  description = "Allow ssh inbound traffic"
  vpc_id = aws_vpc.VPC-Shared.id

  ingress = [
    {
        description = "Ssh form outside"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
        security_groups = []
        ipv6_cidr_blocks = []
        self = null
    }
  ]
  egress = [
    {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = null
    }
  ]
  tags = var.default_tags
}