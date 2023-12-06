# file modules/security_group/main.tf

/*
#Security group for Shared-Bastion
resource "aws_security_group" "shared-bastion-sg" {
  name = "shared-bastion-sg"
  description = "Allow ssh inbound traffic"
  vpc_id = var.vpc_id

  ingress = [
    {
        description = "Ssh from outside"
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

#Security group for Shared-VM1
resource "aws_security_group" "shared-vm1-sg" {
  name = "shared-vm1-sg"
  description = "Allow ssh from shared-bastion and icmp from shared-vm2"
  vpc_id = var.vpc_id

  ingress = [
    {
        description = "Ssh from shared-bastion"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = []
        prefix_list_ids = []
        security_groups = [aws_security_group.shared-bastion-sg.id]
        ipv6_cidr_blocks = []
        self = null
    },
    {
        cidr_blocks = ["10.0.4.0/24"]
        from_port   = 8
        to_port     = 0
        protocol    = "icmp"
        description = "Ping from shared-vm2"
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

#Security group for Shared-VM2
resource "aws_security_group" "shared-vm2-sg" {
  name = "shared-vm2-sg"
  description = "Allow ssh from shared-bastion and icmp from shared-vm1"
  vpc_id = aws_vpc.VPC-Shared.id

  ingress = [
    {
        description = "Ssh from shared-bastion"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = []
        prefix_list_ids = []
        security_groups = [aws_security_group.shared-bastion-sg.id]
        ipv6_cidr_blocks = []
        self = null
    },
    {
        cidr_blocks = ["10.0.3.0/24"]
        from_port   = 8
        to_port     = 0
        protocol    = "icmp"
        description = "Ping from shared-vm1"
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
*/
#Create security group
resource "aws_security_group" "sg" {
  name_prefix = var.name_prefix
  vpc_id = data.aws_vpc.this.id
  tags = var.tags
}

#Create security group rule
resource "aws_security_group_rule" "sg_rule" {
  type = var.type
  from_port = var.from_port
  to_port = var.to_port
  protocol = var.protocol
  security_group_id = aws_security_group.sg.id
  cidr_blocks = var.cidr_blocks
}