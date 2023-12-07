# file modules/key_pair/main.tf

resource "aws_key_pair" "keypair" {
  key_name   = var.key_name  
  public_key = file("./project-key.pem") 
}