resource "aws_vpc" "arka-dev" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  # tags = {
  #   Name = var.vpc_name
  # }
  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}