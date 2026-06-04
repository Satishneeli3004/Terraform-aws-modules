resource "aws_lb_target_group" "this" {

  name = var.name

  port = var.port

  protocol = var.protocol

  vpc_id = var.vpc_id

  target_type = var.target_type

  health_check {

    enabled = true

    path = var.health_check_path

    protocol = "HTTP"

    matcher = "200"
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}