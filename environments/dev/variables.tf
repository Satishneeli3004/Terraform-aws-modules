variable "environment" {
  type = string
}

variable "client_name" {
  type = string
}

variable "project_name" {
  type = string
}


variable "cidr_block" {
  type        = string
  description = "vpc-dev"
}

variable "vpc_name" {
  type        = string
  description = "enter the vpc name"
}

variable "public_route_table_name" {
  type = string
}

variable "private_route_table_name" {
  type = string
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "public_subnet_cidrs" { 
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "igw_name" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "nat_name" {
  type = string
}

variable "allowed_ips" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

# variable "app_sg_rules" {
#   description = "Application Security Group Rules"

#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#   }))
# }

variable "security_groups" {

  type = map(object({

    description = string

    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))

  }))

}