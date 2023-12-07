# file modules/security_group/output.tf

output "sg_id" {
  value = aws_security_group.sg.id
}
