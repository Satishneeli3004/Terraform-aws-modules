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

variable "security_groups" {

  type = map(object({

    description = string

    ingress_rules = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))

  }))

}

variable "ami_id" {
  type = string
}

variable "windows_ami_id" {
  description = "AMI ID for Windows EC2 instance"
  type        = string
}

variable "master_instance_type" {
  type = string
  # default = "t3.medium"
}

variable "worker_instance_type" {
  type = string
  # default = "t3.medium"
}