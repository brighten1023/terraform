# file modules/security_group_rule/variables.tf

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

variable "security_group_id" {
  type = string
}

variable "cidr_blocks" {
  type = list(any)
}

variable "description" {
  type = string
}

variable "source_security_group_id" {
  type = string
}