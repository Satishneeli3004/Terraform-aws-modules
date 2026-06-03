variable "vpc_id" {}
variable "sg_name" {}

# variable "allowed_ips" {
#   default = ["0.0.0.0/0"]
# }
variable "tags" {
  type = map(string)
}


variable "ingress_rules" {
  description = "Security Group Ingress Rules"

  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

