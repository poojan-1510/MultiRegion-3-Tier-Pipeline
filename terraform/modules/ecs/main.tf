locals {
  app_name    = "Project2 Backend"
  name_prefix = "project2-backend" # fixed prefix for consistency
}


resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${local.name_prefix}"
  retention_in_days = 30
}


resource "aws_ecs_cluster" "this" {
  name = "project2-cluster"

  tags = merge(
    { Name = "project2-cluster" },
    var.tags
  )
}

data "aws_region" "current" {}

resource "aws_ecs_task_definition" "backend" {
  family                   = "${local.name_prefix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "${local.name_prefix}-container"
      image = var.container_image

      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        for key, value in var.environment :
        { name = key, value = value }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = data.aws_region.current.name
          awslogs-group         = "/ecs/${local.name_prefix}"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "backend" {
  name            = "${local.name_prefix}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    security_groups  = var.security_group_ids
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${local.name_prefix}-container"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

}
