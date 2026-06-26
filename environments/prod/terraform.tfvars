environment              = "prod"
client_name              = "arka"
project_name             = "networking"
igw_name                 = "arka-prod-igw"
nat_name                 = "arka-prod-nat"
sg_name                  = "arka-prod-sg"
# cidr_block               = "10.0.0.0/16"
cidr_block               = "192.0.0.0/16"
vpc_name                 = "arka-prod-vpc"
public_route_table_name  = "public-rt"
private_route_table_name = "private-rt"
# private_subnet_cidrs     = ["10.0.4.0/24", "10.0.3.0/24"]
# public_subnet_cidrs      = ["10.0.5.0/24", "10.0.2.0/24"]
private_subnet_cidrs     = ["192.0.4.0/24", "192.0.3.0/24"]
public_subnet_cidrs      = ["192.0.5.0/24", "192.0.2.0/24"]
aws_region   = "ap-south-1"
bucket_name = "satish-terraform-state-prod"
dynamodb_name = "terraform-state-locks"
# security_groups = {

#   bastion = {

#     description = "SSH Access"

#     ingress_rules = [
#       {
#         description = "SSH Access"
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   }

#   app = {

#     description = "Application"

#     ingress_rules = [
#       {
#         description = "HTTPS Access"
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "SSH Access"
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "Apache Tomcat port Range"
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   }

#   test = {

#     description = "SSH Access"

#     ingress_rules = [
#       {
#         description = "SSH Access"
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   }
#   central = {

#     description = "SSH Access"

#     ingress_rules = [
#       {
#         description = "SSH Access"
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   }
# }

ami_id               = "ami-07a00cf47dbbc844c"
windows_ami_id       = "ami-05fdee25803e36cbc"
worker_instance_type = "t3.small"
master_instance_type = "t3.small"

security_groups = {

  bastion = {

    description = "Bastion"

    ingress_rules = [

      {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"

        cidr_blocks = [
          "175.101.156.171/32"
        ]
      }

    ]
  }

  windows = {

    description = "windows-instance-sg"

    ingress_rules = [

      {
        description = "RDP Access"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"

        cidr_blocks = [
          "175.101.156.171/32"
        ]
      }

    ]
  }

  k8s-master = {

    description = "Kubernetes Master"

    ingress_rules = [

      {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"

        cidr_blocks = [
          "10.0.0.0/16"
        ]
      },

      {
        description = "Kubernetes API Server"
        from_port   = 6443
        to_port     = 6443
        protocol    = "tcp"

        cidr_blocks = [
          "10.0.0.0/16"
        ]
      }
    ]
  }

  k8s-worker = {

    description = "Worker"

    ingress_rules = [

      {
        description = "SSH Access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"

        cidr_blocks = [
          "10.0.0.0/16"
        ]
      },

      {
        description = "Kubelet"
        from_port   = 10250
        to_port     = 10250
        protocol    = "tcp"

        cidr_blocks = [
          "10.0.0.0/16"
        ]
      }
    ]
  }

  alb = {

    description = "ALB"

    ingress_rules = [

      {
        description = "HTTP Access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
      },

      {
        description = "HTTPS Access"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
      }

    ]
  }
}