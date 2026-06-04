resource "aws_lb" "this" {

  name               = var.alb_name

  internal           = var.internal

  load_balancer_type = "application"

  security_groups    = var.security_group_ids

  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = var.alb_name
    }
  )
}