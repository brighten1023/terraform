# file modules/security_group/variables.tf

variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "description" {
  type = string
}