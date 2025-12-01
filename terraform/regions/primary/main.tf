# module "iam" {
#   source       = "../../modules/iam"
#   project_name = var.project_name
#   account_id   = var.account_id
# }

# module "ecr" {
#   source   = "../../modules/ecr"
#   app_name = var.app_name
# }

# module "frontend_s3" {
#   source     = "../../modules/s3"
#   app_name   = var.app_name
#   source_dir = var.source_dir
# }

# module "frontend_cloudfront" {
#   source                         = "../../modules/cloudfront"
#   app_name                       = var.app_name
#   s3_bucket_name                 = module.frontend_s3.frontend_bucket_name
#   s3_bucket_arn                  = module.frontend_s3.frontend_bucket_arn
#   s3_bucket_regional_domain_name = module.frontend_s3.frontend_bucket_regional_domain_name
# }


module "iam" {
  source      = "../../modules/iam"
  app_name    = var.app_name
  account_id  = var.account_id
  github_org  = "poojan-1510"
  github_repo = "MultiRegion-3-Tier-Pipeline"

  project_name = var.app_name
}


module "network" {
  source          = "../../modules/network"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "security_groups" {
  source         = "../../modules/security_groups"
  app_name       = var.app_name
  container_port = 3000
  vpc_id         = module.network.vpc_id
}

module "alb" {
  source             = "../../modules/alb"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnets
  app_name           = var.app_name
  security_group_ids = [module.security_groups.alb_sg_id]
}

module "ecr" {
  source   = "../../modules/ecr"
  app_name = var.app_name
}

module "s3" {
  source     = "../../modules/s3"
  app_name   = var.app_name
  source_dir = var.source_dir
}

module "cloudfront" {
  source                         = "../../modules/cloudfront"
  app_name                       = var.app_name
  s3_bucket_name                 = module.s3.frontend_bucket_name
  s3_bucket_arn                  = module.s3.frontend_bucket_arn
  s3_bucket_regional_domain_name = module.s3.frontend_bucket_regional_domain_name
}


module "ecs" {
  source             = "../../modules/ecs"
  app_name           = var.app_name
  vpc_id             = module.network.vpc_id
  cluster_name       = "${var.app_name}-cluster"
  container_image    = module.ecr.backend_repo_url
  container_port     = 3000
  private_subnet_ids = module.network.private_subnets
  security_group_ids = [module.security_groups.ecs_sg_id]
  target_group_arn   = module.alb.target_group_arn
  environment = {
    NODE_ENV = "production"
  }
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn

  tags = {
    Project = var.project_name
  }
}
