variable "vpc_id" {}
variable "gateway_id" {}
variable "subnet_ids" {}

variable "public" {
  type = bool
}

# variable "route_table_name" {}
variable "route_table_name" {
  type = string
}

variable "tags" {
  type = map(string)
}
