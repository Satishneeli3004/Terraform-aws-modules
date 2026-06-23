module "security_groups" {

  for_each = var.security_groups

  source = "../../modules/security_group"

  vpc_id = module.vpc.vpc_id

  sg_name = "${var.client_name}-${var.environment}-${each.key}-sg"

  ingress_rules = each.value.ingress_rules

  tags = local.common_tags
}


module "vpc" {
  source = "../../modules/vpc"

  # vpc_name   = "dev-vpc"
  # cidr_block = "10.0.0.0/16"
  cidr_block = var.cidr_block
  # vpc_name   = var.vpc_name
  vpc_name = "${var.client_name}-${var.environment}-vpc"
  tags     = local.common_tags
}

module "public_subnet" {
  source = "../../modules/subnet"

  vpc_id = module.vpc.vpc_id

  subnet_name = "public"

  # subnet_cidrs = [
  #   "10.0.1.0/24"
  # ]
  subnet_cidrs = var.public_subnet_cidrs

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnet = true
  tags          = local.common_tags
}

module "private_subnet" {
  source = "../../modules/subnet"

  vpc_id = module.vpc.vpc_id

  subnet_name = "private"

  # subnet_cidrs = [
  #   "10.0.2.0/24"
  # ]
  subnet_cidrs = var.private_subnet_cidrs

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnet = false
  tags          = local.common_tags
}

module "igw" {
  source = "../../modules/internet_gateway"

  vpc_id = module.vpc.vpc_id
  # igw_name = "dev-igw"
  # igw_name= var.igw_name
  igw_name = "${var.client_name}-${var.environment}-igw"
  tags     = local.common_tags
}

module "nat" {
  source = "../../modules/nat_gateway"

  public_subnet_id = module.public_subnet.subnet_ids[0]
  # nat_name         = "dev-nat"
  # nat_name= var.nat_name
  nat_name   = "${var.client_name}-${var.environment}-nat"
  depends_on = [module.igw]
  tags       = local.common_tags
}


module "public_rt" {
  source = "../../modules/route_table"

  vpc_id = module.vpc.vpc_id

  gateway_id = module.igw.igw_id

  subnet_ids = module.public_subnet.subnet_ids

  public = true

  # route_table_name = "public-rt"
  route_table_name = var.public_route_table_name
  tags             = local.common_tags
}


module "private_rt" {
  source = "../../modules/route_table"

  vpc_id = module.vpc.vpc_id

  gateway_id = module.nat.nat_gateway_id

  subnet_ids = module.private_subnet.subnet_ids

  public = false

  # route_table_name = "private-rt"
  route_table_name = var.private_route_table_name
  tags             = local.common_tags
}



module "keypair" {

  source = "../../modules/keypair"

  key_name = "${var.client_name}-${var.environment}-key"

  tags = local.common_tags
}

# module "Deploy-Windows-server" {

#   source = "../../modules/ec2"

#   instance_name = "Windows-server"

#   # ami_id = var.ami_id
#   ami_id = var.windows_ami_id

#   instance_type = "t3.micro"
#   root_volume_size = 30

#   subnet_id = module.public_subnet.subnet_ids[0]

#   security_group_ids = [
#     module.security_groups["windows"].security_group_id
#   ]

#   key_name = module.keypair.key_name

#   user_data = file("${path.module}/userdata/apache.sh")

#   tags = local.common_tags
# }


module "web-elk-server" {

  source = "../../modules/ec2"

  instance_name = "web-server"

  ami_id = var.ami_id

  instance_type = "t3.small"
  # instance_type    = "m7i-flex.large"
  root_volume_size = 20

  subnet_id = module.public_subnet.subnet_ids[0]

  security_group_ids = [
    module.security_groups["web-bastion-sg"].security_group_id
  ]

  key_name = module.keypair.key_name

  user_data = file("${path.module}/userdata/nginx.sh")

  tags = local.common_tags
}

module "elk-server-1" {

  source = "../../modules/ec2"

  instance_name = "elk-server-1"

  ami_id = var.ami_id

  # instance_type    = "t3.small"
  instance_type    = "m7i-flex.large"
  root_volume_size = 20

  subnet_id = module.private_subnet.subnet_ids[0]

  security_group_ids = [
    module.security_groups["elk-sg"].security_group_id
  ]

  key_name = module.keypair.key_name

  user_data = file("${path.module}/userdata/elk-server.sh")

  tags = local.common_tags
}

module "elk-server-2" {

  source = "../../modules/ec2"

  instance_name = "elk-server-2"

  ami_id = var.ami_id

  # instance_type    = "t3.small"
  instance_type    = "m7i-flex.large"
  root_volume_size = 20

  subnet_id = module.private_subnet.subnet_ids[0]

  security_group_ids = [
    module.security_groups["elk-sg"].security_group_id
  ]

  key_name = module.keypair.key_name

  user_data = file("${path.module}/userdata/elk-server2.sh")

  tags = local.common_tags
}

module "appserver" {

  source = "../../modules/ec2"

  instance_name = "app-server"

  ami_id           = var.ami_id
  root_volume_size = 20

  instance_type = "m7i-flex.large"

  subnet_id = module.private_subnet.subnet_ids[0]

  security_group_ids = [
    module.security_groups["app-sg"].security_group_id
  ]

  key_name = module.keypair.key_name

  user_data = file("${path.module}/userdata/app-server.sh")

  tags = local.common_tags
}