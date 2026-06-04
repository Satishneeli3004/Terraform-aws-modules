variable "alb_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "internal" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(string)
}