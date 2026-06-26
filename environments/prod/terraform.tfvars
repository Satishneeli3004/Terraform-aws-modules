environment              = "UAT"
client_name              = "test"
project_name             = "networking"
igw_name                 = "test-UAT-igw"
nat_name                 = "test-UAT-nat"
sg_name                  = "test-UAT-sg"
cidr_block               = "192.0.0.0/16"
vpc_name                 = "test-UAT-vpc"
public_route_table_name  = "public-rt"
private_route_table_name = "private-rt"
private_subnet_cidrs     = ["192.0.4.0/24"]
public_subnet_cidrs      = ["192.0.5.0/24"]

ami_id               = "ami-07a00cf47dbbc844c"
windows_ami_id       = "ami-05fdee25803e36cbc"
worker_instance_type = "t3.small"
master_instance_type = "t3.small"

security_groups = {

  jenkins = {

    description = "Jenkins Server"

    ingress_rules = [

      {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"

        cidr_blocks = [
          "175.101.156.223/32"  #Use Public IP
        ]
      },

      {
        description = "Jenkins UI"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"

        cidr_blocks = [
          "0.0.0.0/0"
        ]
      }

    ]
  }

  sonarqube = {

    description = "SonarQube Server"

    ingress_rules = [

      {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"

        cidr_blocks = [
          "175.101.156.223/32"  #Use Public IP
        ]
      },

      {
        description = "SonarQube UI"
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"

        cidr_blocks = [
          "0.0.0.0/0"
        ]
      }

    ]
  }

}