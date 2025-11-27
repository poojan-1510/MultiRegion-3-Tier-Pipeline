module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  account_id   = var.account_id
}

module "ecr" {
  source   = "../../modules/ecr"
  app_name = var.app_name
}

module "frontend_s3" {
  source     = "../../modules/s3"
  app_name   = var.app_name
  source_dir = var.source_dir
}

module "frontend_cloudfront" {
  source                         = "../../modules/cloudfront"
  app_name                       = var.app_name
  s3_bucket_name                 = module.frontend_s3.frontend_bucket_name
  s3_bucket_arn                  = module.frontend_s3.frontend_bucket_arn
  s3_bucket_regional_domain_name = module.frontend_s3.frontend_bucket_regional_domain_name
}


# module "network" {
#   source          = "../../modules/network"
#   vpc_cidr        = var.vpc_cidr
#   public_subnets  = var.public_subnets
#   private_subnets = var.private_subnets
#   region          = var.region
# }

# module "iam" {
#   source       = "../../modules/iam"
#   project_name = "project2"
# }

# module "ecs" {
#   source = "../../modules/ecs"

#   app_name = var.app_name

#   backend_image         = var.backend_image_tag
#   backend_task_role_arn = module.iam.backend_task_role_arn

#   db_host         = module.rds.endpoint
#   db_user         = var.db_user
#   db_name         = var.db_name
#   db_password_arn = module.rds.db_password_secret_arn

#   private_subnets = module.network.private_subnets
#   backend_sg_id   = module.security.backend_sg_id

#   backend_tg_arn          = module.alb.backend_tg_arn
#   backend_tg_listener_arn = module.alb.backend_listener_arn
# }
