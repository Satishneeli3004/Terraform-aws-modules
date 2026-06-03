variable "cidr_block" {
  type        = string
  description = "vpc-dev"
}

variable "vpc_name" {
  type        = string
  description = "enter the vpc name"
}

variable "tags" {
  type = map(string)
}
