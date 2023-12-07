# file modules/security_group/main.tf

#Create security group
resource "aws_security_group" "sg" {
  name_prefix = var.name_prefix
  vpc_id = var.vpc_id
  tags = var.tags
  description = var.description
}

