# file modules/peering/variables.tf

variable "vpc_id" {
  type = string
}

variable "peer_vpc_id" {
  type = string
}

variable "source_route_table_id" {
  type = string
}

variable "dest_route_table_id" {
  type = string
}

variable "source_cidr" {
  type = string
}

variable "dest_cidr" {
  type = string
}