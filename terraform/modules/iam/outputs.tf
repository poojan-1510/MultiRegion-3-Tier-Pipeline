output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  value = var.enable_task_role ? aws_iam_role.ecs_task_role.arn : null
}
output "github_oidc_role_arn" {
  value = aws_iam_role.ecr_ci_role.arn
}
