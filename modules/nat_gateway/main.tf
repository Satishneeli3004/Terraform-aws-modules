resource "aws_eip" "arka-dev" {
  domain = "vpc"
}

resource "aws_nat_gateway" "arka-dev" {
  allocation_id = aws_eip.arka-dev.id
  subnet_id     = var.public_subnet_id

  # tags = {
  #   Name = var.nat_name
  # }
  tags = merge(
  var.tags,
    {
      Name = var.nat_name
    }
  )

  depends_on = [aws_eip.arka-dev]
}