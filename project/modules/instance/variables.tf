# file modules/instance/variables.tf

variable "name" {
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

variable "tags" {
    type = map(string)
}

variable "associate_public_ip_address" {
    type = bool
}

variable "file_path" {
    type = string
}