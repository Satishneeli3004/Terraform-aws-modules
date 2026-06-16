variable "instance_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "user_data" {
  type    = string
  default = null
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type    = number
  default = 20
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type    = string
  default = "gp3"
}

variable "tags" {
  type = map(string)
}