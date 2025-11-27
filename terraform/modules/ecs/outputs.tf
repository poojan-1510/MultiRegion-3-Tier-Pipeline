output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "backend_service_name" {
  value = aws_ecs_service.backend.name
}

output "backend_task_definition_arn" {
  value = aws_ecs_task_definition.backend.arn
}
