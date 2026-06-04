variable "name" {}

variable "port" {}

variable "protocol" {}

variable "vpc_id" {}

variable "target_type" {
  default = "instance"
}

variable "health_check_path" {
  default = "/"
}

variable "tags" {
  type = map(string)
}