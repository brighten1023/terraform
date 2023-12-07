# file modules/key_pair/output.tf

output "key_name" {
  value = aws_key_pair.keypair.key_name
}