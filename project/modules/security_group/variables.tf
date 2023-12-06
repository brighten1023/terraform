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

variable "type" {
  type = string
}

variable "from_port" {
  type = number
}

variable "to_port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "cidr_blocks" {
  type = list(any)
}