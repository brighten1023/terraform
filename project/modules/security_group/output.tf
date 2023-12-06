# file modules/security_group/output.tf

/*
#output of sg
output "bastion_sg_id" {
  value = aws_security_group.shared-bastion-sg.id
}

output "vm1_sg_id" {
  value = aws_security_group.shared-vm1-sg.id
}

output "vm2_sg_id" {
  value = aws_security_group.shared-vm2-sg.id
}
*/

output "sg_id" {
  value = aws_security_group.sg.id
}
