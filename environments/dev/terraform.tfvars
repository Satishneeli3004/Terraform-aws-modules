cidr_block = "10.0.0.0/16"
vpc_name   = "arka-dev-vpc"
igw_name = "arka-dev-igw"
nat_name = "arka-dev-nat"
sg_name = "arka-dev-sg"
public_route_table_name  = "public-rt"
private_route_table_name = "private-rt"
private_subnet_cidrs = ["10.0.2.0/24"]
public_subnet_cidrs = ["10.0.1.0/24"]


security_groups = {

  bastion = {

    description = "SSH Access"

    ingress_rules = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}