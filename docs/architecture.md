# Project Structure – Multi-Region 3-Tier CI/CD Platform

/project-root
/app/
/frontend/ # UI tier (React / Angular / Vue etc.)
/backend/ # API tier (Node / Python / Java etc.)
/database/ # DB migrations / schema / seed scripts
/docker/
/frontend/ # Dockerfile + env templates
/backend/ # Dockerfile + env templates
/database/ # Optional init/migration container
.gitlab-ci.yml # CI pipeline (build + test + push images to ECR)
/deploy/ # CD pipeline (deploy using image tags)
/environments/
/dev/
/stage/
/prod/
/terraform/
/modules/
/network/ # VPC, subnets, NAT, routing
/ecs/ # ECS cluster + services for 3 tiers
/alb/ # Public ALB (frontend) + internal ALB (backend)
/rds/ # Database tier if using RDS/Aurora
/iam/ # IAM roles, policies, task execution roles
/regions/
/primary/ # Primary AWS region deployment
/dr/ # DR region infra (warm standby)
/ansible/
/ops/ # DR promotion, smoke tests, operational workflows
/config/ # Config tasks not suited for Terraform
/docs/
architecture.md
dr-strategy.md
runbooks.md
```markdown
✅ Fully aligned with:
- 3-tier application separation (frontend, backend, DB)
- separated CI and CD pipelines
- ECS Fargate deployment model
- ECR artifact storage
- multi-region DR support
- Terraform for infra
- Ansible for ops/runbooks