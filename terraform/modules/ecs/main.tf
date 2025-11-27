############################
# ECS Cluster
############################
resource "aws_ecs_cluster" "this" {
  name = "${var.app_name}-cluster"
}

############################
# Task Execution Role
############################
resource "aws_iam_role" "execution_role" {
  name = "${var.app_name}-ecs-exec-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

############################
# Task Definition (Backend)
############################
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.app_name}-backend"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = var.backend_task_role_arn

  container_definitions = jsonencode([
    {
      name  = "backend"
      image = var.backend_image
      portMappings = [{
        containerPort = 3000
        protocol      = "tcp"
      }]
      environment = [
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_USER", value = var.db_user },
        { name = "DB_NAME", value = var.db_name },
      ]
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = var.db_password_arn
        }
      ]
    }
  ])
}

############################
# ECS Service (Backend)
############################
resource "aws_ecs_service" "backend" {
  name            = "${var.app_name}-backend-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.backend_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.backend_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.backend_tg_arn
    container_name   = "backend"
    container_port   = 3000
  }

  depends_on = [var.backend_tg_listener_arn]
}
