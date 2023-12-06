# file modules/instance/variables.tf

variable "ami_id" {
    type = string
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "subnet_id" {
    type = string
}

variable "key_name" {
    type = string
}

variable "vpc_security_group_ids" {
    type = list(any)
}