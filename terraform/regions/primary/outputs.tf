output "frontend_bucket_name" {
  value = module.s3.frontend_bucket_name
}

output "frontend_bucket_arn" {
  value = module.s3.frontend_bucket_arn
}

output "frontend_bucket_regional_domain_name" {
  value = module.s3.frontend_bucket_regional_domain_name
}

output "frontend_cloudfront_domain" {
  value = module.cloudfront.frontend_cloudfront_domain
}
output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the Application Load Balancer"
}

output "alb_arn" {
  value       = module.alb.alb_arn
  description = "ARN of the Application Load Balancer"
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}
