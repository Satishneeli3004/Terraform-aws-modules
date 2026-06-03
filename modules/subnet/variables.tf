variable "vpc_id" {}
# variable "subnet_cidrs" {}
variable "subnet_cidrs" {
  type        = list(string)
  description = "Subnet CIDR blocks"
}
variable "availability_zones" {}

variable "public_subnet" {
  default = false
}

variable "subnet_name" {}

variable "tags" {
  type = map(string)
}