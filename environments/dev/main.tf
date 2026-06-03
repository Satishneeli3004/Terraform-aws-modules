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
  tags = local.common_tags
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
    "ap-south-1a"
  ]

  public_subnet = true
  tags = local.common_tags
}

# module "private_subnet" {
#   source = "../../modules/subnet"

#   vpc_id = module.vpc.vpc_id

#   subnet_name = "private"

#   # subnet_cidrs = [
#   #   "10.0.2.0/24"
#   # ]
#   subnet_cidrs = var.private_subnet_cidrs

#   availability_zones = [
#     "ap-south-1a"
#   ]

#   public_subnet = false
#   tags = local.common_tags
# }

module "igw" {
  source = "../../modules/internet_gateway"

  vpc_id   = module.vpc.vpc_id
  # igw_name = "dev-igw"
  # igw_name= var.igw_name
  igw_name = "${var.client_name}-${var.environment}-igw"
  tags = local.common_tags
}

# module "nat" {
#   source = "../../modules/nat_gateway"

#   public_subnet_id = module.public_subnet.subnet_ids[0]
#   # nat_name         = "dev-nat"
#   # nat_name= var.nat_name
#   nat_name = "${var.client_name}-${var.environment}-nat"
#   tags = local.common_tags
# }


module "public_rt" {
  source = "../../modules/route_table"

  vpc_id = module.vpc.vpc_id

  gateway_id = module.igw.igw_id

  subnet_ids = module.public_subnet.subnet_ids

  public = true

  # route_table_name = "public-rt"
  route_table_name = var.public_route_table_name
  tags = local.common_tags
}


# module "private_rt" {
#   source = "../../modules/route_table"

#   vpc_id = module.vpc.vpc_id

#   gateway_id = module.nat.nat_gateway_id

#   subnet_ids = module.private_subnet.subnet_ids

#   public = false

#   # route_table_name = "private-rt"
#   route_table_name = var.private_route_table_name
#   tags = local.common_tags
# }



