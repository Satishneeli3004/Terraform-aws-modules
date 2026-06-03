resource "aws_route_table" "public" {
  count = var.public ? 1 : 0

  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  # tags = {
  #   Name = var.route_table_name
  # }
  tags = merge(
  var.tags,
    {
      Name = var.route_table_name
    }
  )
}


resource "aws_route_table" "private" {
  count = var.public ? 0 : 1

  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.gateway_id
  }

  # tags = {
  #   Name = var.route_table_name
  # }
  tags = merge(
  var.tags,
    {
      Name = var.route_table_name
    }
  )
}


resource "aws_route_table_association" "arka-dev" {
  count = length(var.subnet_ids)

  subnet_id      = var.subnet_ids[count.index]
  route_table_id = var.public ? aws_route_table.public[0].id : aws_route_table.private[0].id
}