Project definition — CI / CD separated
--------------------------------------------------------------------------------------------------
Title: GitLab CI (build) → Amazon ECR (artifact) → GitLab CD (deploy) → AWS ECS Fargate 
(multi-region DR)
--------------------------------------------------------------------------------------------------
Infra automation: Terraform
Post-provision config / orchestration: Ansible
--------------------------------------------------------------------------------------------------
Purpose
--------------------------------------------------------------------------------------------------
Keep CI (build + test + push image) and CD (deploy image to environments / regions) as fully separate, auditable pipelines while supporting multi-region disaster recovery (warm-standby by default).
--------------------------------------------------------------------------------------------------
High-level components & responsibilities
--------------------------------------------------------------------------------------------------
CI (Build-only) — GitLab CI
--------------------------------------------------------------------------------------------------
Responsibility: produce immutable, tested container images and publish them to ECR.
Steps:
Checkout code
Build Docker image
Run tests (unit/integration)
Tag image (app:$CI_COMMIT_SHA or semver)
Authenticate to ECR (primary region)
Push image to ECR primary
Publish small artifact with metadata:
image_tag.txt (the tag)
image_uri_primary.txt (ECR URI in primary)
Outputs (artifacts): image in ECR (primary), text artifact(s) with image tag/URI.
--------------------------------------------------------------------------------------------------
CD (Deploy-only) — GitLab CD (separate pipeline / project)
Responsibility: deploy a specific image (from CI) to ECS Fargate per-region clusters and handle promotion/failover logic.
Inputs: image_tag and/or image URI produced by CI (pulled via artifact, API call or pipeline trigger).
Steps (typical warm-standby flow):
Deploy to Primary region ECS cluster (register new task definition using image URI).
Wait for ALB health checks / deployment stabilization.
Run verification tests (smoke tests).
If successful, optionally deploy to DR region (warm standby) or keep DR updated asynchronously.
On failure, run rollback steps (previous task revision) and notify.
Triggers: manual, scheduled, or triggered by CI via secure API trigger (preferred) — but CD must not rebuild images.
--------------------------------------------------------------------------------------------------
Artifact storage
Primary artifact: Docker image in Amazon ECR (primary region).
Replication: ECR cross-region replication to DR region(s) so images are available for failover.
--------------------------------------------------------------------------------------------------
Runtime
ECS Fargate clusters — one cluster per region.
ALB per region (public or internal depending on needs).
Datastore: RDS (Multi-AZ in-region) plus cross-region read replica and backup/promotion plan, or DynamoDB Global Tables for NoSQL.
--------------------------------------------------------------------------------------------------
Infrastructure as Code — Terraform
Scope: VPC, subnets, security groups, ECR repos, EKS/ECS infrastructure, ALB, Route53 records, IAM roles/policies, CloudWatch resources.
Organization: modular (vpc, ecs, ecr, iam, rds, route53), and region-specific stacks (primary / dr).
Runs: separate pipelines (plan/apply) with approvals for production changes.
--------------------------------------------------------------------------------------------------
Configuration & orchestration — Ansible
Scope: bastion/utility host config, orchestration scripts for DR promotion (e.g., promote RDS replica), tooling on jump hosts, secrets templating that Terraform shouldn’t manage.
Runs: as needed, called from CI/CD or from an ops runbook.
--------------------------------------------------------------------------------------------------
Multi-region DR model (recommended default)
Warm Standby (Active/Passive)
Primary region serves traffic.
DR region keeps infrastructure running with minimal replicas or healthy tasks (ready to scale).
ECR replicates images.
RDS has read replica in DR region (promote on failover) or regular backups restored quickly.
Route53 health-check + failover policy or Global Accelerator used to switch traffic.
Failover steps (short):
Promote DR RDS replica (if DB involved).
Ensure ECS tasks in DR are using the replicated ECR image (register task def if needed).
Switch Route53 to point to DR ALB (automatic via health checks or manual with runbook/Ansible).
Validate and monitor.
--------------------------------------------------------------------------------------------------
CI / CD separation mechanics (how pipelines talk)
CI produces image_tag.txt artifact and pushes image to ECR.
CI triggers CD pipeline via a secure GitLab trigger endpoint OR stores metadata in a central place (artifact store / GitLab release / S3) that CD reads.
CD downloads artifact or receives the image tag and uses it to update ECS task definitions — no image building in CD.
--------------------------------------------------------------------------------------------------
Security & access
CI uses an AWS IAM user/role with minimal permissions: ECR push, STS assume-role to limited scope.
CD uses a different IAM role with permissions to register ECS task definitions, update services, read ECR (pull).
Terraform uses a dedicated service principal / role with permissions limited by environment and scoped by region.
Secrets: put runtime secrets in Secrets Manager or SSM Parameter Store; use IAM roles for task execution.
--------------------------------------------------------------------------------------------------
Observability & Verification
CloudWatch logs for tasks; ALB health checks; CloudWatch alarms; automatic rollback on failure detection in CD pipeline.
Smoke tests in CD after deployment; rollback on failed smoke tests.