# file modules/instance/main.tf

#Create instance
resource "aws_instance" "instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_name
  monitoring = true
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  tags = var.tags
}

data "aws_ami" "ami-amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

}
data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}
