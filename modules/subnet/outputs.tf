output "subnet_ids" {
  value = aws_subnet.arka-dev[*].id
}