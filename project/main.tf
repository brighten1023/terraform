terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
      }
    }
}

#AWS Provider
provider "aws" {
    region = "us-east-1"
    shared_credentials_file = ".aws/credentials"
}

/*
#Create key pair
module "key" {
  source = "./modules/key_pair"
  key_name = "project-key"
}
*/

#Create VPC, subnets, igw, nat in shared network
module "shared_networking" {
  source = "./modules/networking"
  vpc_cidr = "10.0.0.0/16"
  public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  tags = {Name = "Shared-VPC"}
}

#Create shared-bastion sg
module "shared_bastion_sg" {
  source = "./modules/security_group"
  name_prefix = "shared_bastion_sg"
  tags = {Name = "shared_bastion_sg"}
  description = "Allow ssh inbound traffic, allow any outbound traffic"
  vpc_id = module.shared_networking.vpc_id
}

#Create shared-vm1 sg
module "shared_vm1_sg" {
  source = "./modules/security_group"
  name_prefix = "shared_vm1_sg"
  tags = {Name = "shared_vm1_sg"}
  description = "Allow ssh from shared-bastion and icmp from shared-vm2"
  vpc_id = module.shared_networking.vpc_id
}

#Create shared-vm2 sg
module "shared_vm2_sg" {
  source = "./modules/security_group"
  name_prefix = "shared_vm2_sg"
  tags = {Name = "shared_vm2_sg"}
  description = "Allow ssh from shared-bastion and icmp from shared-vm1"
  vpc_id = module.shared_networking.vpc_id
}

#Create sg ingress rule that allow ssh from outside for shared-bastion sg
module "shared_bastion_sg_rule_ingress" {
  source = "./modules/security_group_rule"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.shared_bastion_sg.sg_id
  description = "Ssh from outside"
  source_security_group_id = ""
}

#Create sg egress rule that allow all traffic for shared-bastion
module "shared_bastion_sg_rule_egress" {
  source = "./modules/security_group_rule"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.shared_bastion_sg.sg_id
  description = "Allow all outbound traffic"
  source_security_group_id = ""
}

#Create sg ingress rule that allow ssh from shared-bastion for shared-vm1
module "shared_vm1_sg_rule_ingress_ssh" {
  source = "./modules/security_group_rule"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [""]
  security_group_id = module.shared_vm1_sg.sg_id
  description = "Ssh from shared-bastion"
  source_security_group_id = module.shared_bastion_sg.sg_id
}

#Create sg ingress rule that allow ping from shared-vm2 for shared-vm1
module "shared_vm1_sg_rule_ingress_ping" {
  source = "./modules/security_group_rule"
  type = "ingress"
  from_port = 8
  to_port = 0
  protocol = "icmp"
  cidr_blocks = [""]
  security_group_id = module.shared_vm1_sg.sg_id
  description = "Ping from shared-vm2"
  source_security_group_id = module.shared_vm2_sg.sg_id
}

#Create sg egress rule that allow all traffic for shared-vm1
module "shared_vm1_sg_rule_egress" {
  source = "./modules/security_group_rule"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.shared_vm1_sg.sg_id
  description = "Allow all outbound traffic"
  source_security_group_id = ""
}

#Create sg ingress rule that allow ssh from shared-bastion for shared-vm2
module "shared_vm2_sg_rule_ingress_ssh" {
  source = "./modules/security_group_rule"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [""]
  security_group_id = module.shared_vm2_sg.sg_id
  description = "Ssh from shared-bastion"
  source_security_group_id = module.shared_bastion_sg.sg_id
}

#Create sg ingress rule that allow ping from shared-vm1 for shared-vm2
module "shared_vm2_sg_rule_ingress_ping" {
  source = "./modules/security_group_rule"
  type = "ingress"
  from_port = 8
  to_port = 0
  protocol = "icmp"
  cidr_blocks = [""]
  security_group_id = module.shared_vm2_sg.sg_id
  description = "Ping from shared-vm1"
  source_security_group_id = module.shared_vm1_sg.sg_id
}

#Create sg ingress rule that allow ping from dev-vm1 for shared-vm2
module "shared_vm2_sg_rule_ingress_ping_dev" {
  source = "./modules/security_group_rule"
  type = "ingress"
  from_port = 8
  to_port = 0
  protocol = "icmp"
  cidr_blocks = [""]
  security_group_id = module.shared_vm2_sg.sg_id
  description = "Ping from shared-vm1"
  source_security_group_id = module.dev_vm1_sg.sg_id
}

#Create sg egress rule that allow all traffic for shared-vm2
module "shared_vm2_sg_rule_egress" {
  source = "./modules/security_group_rule"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.shared_vm2_sg.sg_id
  description = "Allow all outbound traffic"
  source_security_group_id = ""
}

#Create shared_bastion instance
module "shared_bastion" {
  source = "./modules/instance"
  instance_type = "t2.micro"
  name = "Shared-Bastion"
  key_name = "vockey"
  subnet_id = module.shared_networking.public_subnet_ids[0].id
  vpc_security_group_ids = [module.shared_bastion_sg.sg_id]
  associate_public_ip_address = true
  tags = {Name = "Shared-Bastion"}
}

#Create shared_vm1 instance
module "shared_vm1" {
  source = "./modules/instance"
  instance_type = "t2.micro"
  name = "Shared-vm1"
  key_name = "vockey"
  subnet_id = module.shared_networking.private_subnet_ids[0].id
  vpc_security_group_ids = [module.shared_vm1_sg.sg_id]
  associate_public_ip_address = false
  tags = {Name = "Shared-VM1"}
}

#Create shared_vm2 instance
module "shared_vm2" {
  source = "./modules/instance"
  instance_type = "t2.micro"
  name = "Shared-vm2"
  key_name = "vockey"
  subnet_id = module.shared_networking.private_subnet_ids[1].id
  vpc_security_group_ids = [module.shared_vm2_sg.sg_id]
  associate_public_ip_address = false
  tags = {Name = "Shared-VM2"}
}

#Create VPC, subnets, igw, nat in dev network
module "dev_networking" {
  source = "./modules/networking"
  vpc_cidr = "192.168.0.0/16"
  public_cidrs = ["192.168.1.0/24", "192.168.2.0/24"]
  private_cidrs = ["192.168.3.0/24", "192.168.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  tags = {Name = "Dev-VPC"}
}

#Create peering connection
module "peering_connection" {
  source = "./modules/peering"
  peer_vpc_id = module.dev_networking.vpc_id
  vpc_id = module.shared_networking.vpc_id
  source_route_table_id = module.shared_networking.private_table_id
  dest_route_table_id = module.dev_networking.private_table_id
  source_cidr = "10.0.4.0/24"
  dest_cidr = "192.168.3.0/24"
}

#Create dev_vm1 sg
module "dev_vm1_sg" {
  source = "./modules/security_group"
  name_prefix = "dev_vm1_sg"
  tags = {Name = "dev_vm1_sg"}
  description = "Allow icmp from shared-vm2"
  vpc_id = module.dev_networking.vpc_id
}

#Create sg ingress rule that allow ping from shared-vm2 for dev-vm1
module "dev_vm1_sg_rule_ingress_ping_dev" {
  source = "./modules/security_group_rule"
  type = "ingress"
  from_port = 8
  to_port = 0
  protocol = "icmp"
  cidr_blocks = [""]
  security_group_id = module.dev_vm1_sg.sg_id
  description = "Ping from shared-vm2"
  source_security_group_id = module.shared_vm2_sg.sg_id
}

#Create sg egress rule that allow all traffic for dev-vm1
module "dev_vm1_sg_rule_egress" {
  source = "./modules/security_group_rule"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.dev_vm1_sg.sg_id
  description = "Allow all outbound traffic"
  source_security_group_id = ""
}

#Create dev_bastion instance
module "dev_bastion" {
  source = "./modules/instance"
  instance_type = "t2.micro"
  name = "dev-Bastion"
  key_name = "vockey"
  subnet_id = module.dev_networking.public_subnet_ids[0].id
  vpc_security_group_ids = null
  associate_public_ip_address = true
  tags = {Name = "Dev-Bastion"}
}

#Create dev_vm1 instance
module "dev_vm1" {
  source = "./modules/instance"
  instance_type = "t2.micro"
  name = "dev-vm1"
  key_name = "vockey"
  subnet_id = module.dev_networking.private_subnet_ids[0].id
  vpc_security_group_ids = null
  associate_public_ip_address = false
  tags = {Name = "Dev-VM1"}
}

#Create dev_vm2 instance
module "dev_vm2" {
  source = "./modules/instance"
  instance_type = "t2.micro"
  name = "dev-vm2"
  key_name = "vockey"
  subnet_id = module.dev_networking.private_subnet_ids[1].id
  vpc_security_group_ids = null
  associate_public_ip_address = false
  tags = {Name = "Dev-VM2"}
}