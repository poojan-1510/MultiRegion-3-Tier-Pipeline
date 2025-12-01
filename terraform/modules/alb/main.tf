locals {
  name_prefix = replace(lower(var.app_name), " ", "-")
}

# Application Load Balancer (public)
resource "aws_lb" "alb" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  tags = merge(
    {
      Name = "${local.name_prefix}-alb"
      app  = var.app_name
    },
    var.tags
  )
}

# Target Group for Fargate (ip target type)
resource "aws_lb_target_group" "backend_tg" {
  name        = "${local.name_prefix}-backend-tg"
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.target_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = merge(
    {
      Name = "${local.name_prefix}-backend-tg"
      app  = var.app_name
    },
    var.tags
  )
}

# Listener (default forward to the target group)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}
