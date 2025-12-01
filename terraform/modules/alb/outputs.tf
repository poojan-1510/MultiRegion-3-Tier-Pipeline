output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB (use this to access the service)."
  value       = aws_lb.alb.dns_name
}

output "alb_security_group_ids" {
  description = "Security groups attached to the ALB."
  value       = aws_lb.alb.security_groups
}

output "target_group_arn" {
  description = "ARN of the backend target group."
  value       = aws_lb_target_group.backend_tg.arn
}

output "target_group_name" {
  description = "Name of the backend target group."
  value       = aws_lb_target_group.backend_tg.name
}

output "listener_arn" {
  description = "ARN of the listener."
  value       = aws_lb_listener.http.arn
}
