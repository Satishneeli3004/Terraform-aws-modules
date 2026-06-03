resource "aws_internet_gateway" "arka-dev" {
  vpc_id = var.vpc_id

  # tags = {
  #   Name = var.igw_name
  # }
  tags = merge(
    var.tags,
    {
      Name = var.igw_name
    }
  )
}