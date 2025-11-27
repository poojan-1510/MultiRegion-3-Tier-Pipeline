# S3 Outputs
output "frontend_bucket_name" {
  value = module.frontend_s3.frontend_bucket_name
}

output "frontend_bucket_arn" {
  value = module.frontend_s3.frontend_bucket_arn
}

# CloudFront Output
output "frontend_cloudfront_domain" {
  value = module.frontend_cloudfront.frontend_cloudfront_domain
}

# ECR Output
output "backend_repo_url" {
  value = module.ecr.backend_repo_url
}
