# file modules/vpc/variables.tf

variable "vpc_cidr" {
  type = string
}

variable "counter" {
  type = number
  default = 1
}

variable "public_cidrs" {
  type = list(any)
}

variable "private_cidrs" {
  type = list(any)
}

variable "availability_zones" {
  type = list(any)
}