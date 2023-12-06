# file modules/networking/main.tf
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
/*
#Create VPC-Shared VPC
resource "aws_vpc" "VPC-Shared" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { Name = "VPC-Shared" }
}
*/

#Create VPC
resource "aws_vpc" "project_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = var.tags
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
  vpc_id = aws_vpc.project_vpc.id
  count = length(var.public_cidrs)
  availability_zone = var.availability_zones[count.index]
  cidr_block = var.public_cidrs[count.index]
  tags = merge(
    {
        Name = "Public_SN${count.index + 1}"
    }
  )
}

#Create private subnet
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.project_vpc.id
  count = length(var.private_cidrs)
  availability_zone = var.availability_zones[count.index]
  cidr_block = var.private_cidrs[count.index]
  tags = merge(
    {
        Name = "Private_SN${count.index + 1}"
    }
  )
}

#Create internet gateway
resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id
  tags = merge(
    {
        Name = "IGW"
    }
  )
}

#Create EIP
resource "aws_eip" "nat-eip" {
  vpc = true
}

#Create NAT GW
resource "aws_nat_gateway" "project_nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.public[1].id
  tags = merge(
    {
        Name = "NAT-GW"
    }
  )
  depends_on = [ aws_internet_gateway.project_igw ]
}

#Create Public Route Tables in Shared VPC
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.project_vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }
  tags = merge(
    {
        Name = "Public-RT"
    }
  )
}

#Create Private Route Tables in Shared VPC
resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.project_vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.project_nat.id
  }
  tags = merge(
    {
        Name = "private-RT"
    }
  )
}

#Create Route Table Association
resource "aws_route_table_association" "association-pub" {
  count = length(var.public_cidrs)
  subnet_id = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table_association" "association-pr" {
  count = length(var.private_cidrs)
  subnet_id = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.rt-private.id
}
