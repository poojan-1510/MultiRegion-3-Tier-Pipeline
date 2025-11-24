/project-root
  /app/
    /frontend/              # UI tier (React / Angular / Vue etc.)
    /backend/               # API tier (Node / Python / Java etc.)
    /database/              # DB migrations / schema / seed scripts
  /docker/
    /frontend/              # Dockerfile + env templates
    /backend/               # Dockerfile + env templates
    /database/              # If DB init container is used
  .gitlab-ci.yml            # CI pipeline (build + test + push images to ECR)
  /deploy/                  # CD pipeline (uses image tags + deploys to ECS)
    /environments/
      /dev/
      /stage/
      /prod/
  /terraform/
    /modules/
      /network/             # VPC, subnets, routing
      /ecs/                 # ECS cluster, services, task defs for 3 tiers
      /alb/                 # Load balancer for frontend + API
      /rds/                 # Database tier (if not serverless)
      /iam/                 # Roles, policies
    /regions/
      /primary/
      /dr/
  /ansible/
    /ops/                   # DR promotion scripts, smoke tests, runbooks
    /config/                # Any config not managed by Terraform
  /docs/
    architecture.md
    dr-strategy.md
    runbooks.md
