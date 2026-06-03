environment              = "prod"
client_name              = "arka"
project_name             = "networking"
igw_name                 = "arka-prod-igw"
nat_name                 = "arka-prod-nat"
sg_name                  = "arka-prod-sg"
cidr_block               = "10.0.0.0/16"
vpc_name                 = "arka-prod-vpc"
public_route_table_name  = "public-rt"
private_route_table_name = "private-rt"
private_subnet_cidrs     = ["10.0.4.0/24"]
public_subnet_cidrs      = ["10.0.5.0/24"]
security_groups = {

  bastion = {

    description = "SSH Access"

    ingress_rules = [
      {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  app = {

    description = "Application"

    ingress_rules = [
      {
        description = "HTTPS Access"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Apache Tomcat port Range"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  test = {

    description = "SSH Access"

    ingress_rules = [
      {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  central = {

    description = "SSH Access"

    ingress_rules = [
      {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

ami_id = "ami-07a00cf47dbbc844c"