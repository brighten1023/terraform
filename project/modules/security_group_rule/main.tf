# file modules/security_group_rule/main.tf

#Create security group rule
resource "aws_security_group_rule" "sg_rule" {
  type = var.type
  from_port = var.from_port
  to_port = var.to_port
  protocol = var.protocol
  security_group_id = var.security_group_id
  cidr_blocks = var.cidr_blocks != [""] ? var.cidr_blocks : null
  description = var.description
  source_security_group_id = var.source_security_group_id != "" ? var.source_security_group_id : null
  self = null
}