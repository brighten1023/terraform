# file modules/peering/variables.tf

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