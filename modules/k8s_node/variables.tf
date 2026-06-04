variable "instance_name" {}

variable "ami_id" {}

variable "instance_type" {}

variable "subnet_id" {}

variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {}

variable "user_data" {}

variable "volume_size" {
  default = 20
}

variable "tags" {
  type = map(string)
}