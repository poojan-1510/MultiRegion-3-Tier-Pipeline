# Multi-Region 3-Tier CI/CD Platform

This project implements a production-grade **3-tier application delivery platform** with fully separated **CI and CD pipelines**, containerized workloads, AWS-native deployment, and multi-region disaster recovery capability.

---

## 🔷 Architecture Overview

### Three-Tier Application
- **Frontend Tier** – UI (React / Angular / Vue)
- **Backend Tier** – API service (Node / Python / Java / etc.)
- **Database Tier** – schema, migrations, seed data

### CI Pipeline (GitLab CI)
Responsible only for:
- building container images
- running tests
- tagging artifacts
- pushing images to Amazon ECR

### CD Pipeline (GitLab CD)
Responsible only for:
- consuming immutable image tags
- updating task definitions
- deploying to AWS ECS Fargate
- promoting releases across environments (dev → stage → prod)

### Infrastructure-as-Code
- **Terraform** provisions:
  - VPC networking
  - ECS clusters & services
  - ALBs (public + internal)
  - RDS database tier
  - IAM roles and policies
  - multi-region deployment

### Configuration & Ops Automation
- **Ansible** used for:
  - DR promotion workflows
  - smoke testing
  - operational runbooks
  - configuration not suited for Terraform

### Multi-Region Disaster Recovery
- warm standby DR region
- ECR image replication
- ECS failover readiness
- database replica promotion
- Route53 health-based routing

---

## Key Design Principles

CI and CD fully separated  
Immutable container images in ECR  
No build logic inside deployment pipeline  
Tier isolation through networking & security groups  
Backend not exposed publicly  
Database never reachable from internet  
Multi-region resilience without active-active complexity  

---

## 🚀 Deployment Flow

### CI
1. build frontend, backend, (optional migration) images  
2. run unit/integration tests  
3. tag images (`SHA` preferred)  
4. push to ECR  
5. publish image tag artifacts  

### CD
1. retrieve image tags  
2. update ECS task definitions  
3. deploy to primary region  
4. verify via health checks + smoke tests  
5. optionally deploy/promote to DR region  

---

## 🔐 Security Practices

✔ IAM roles instead of static credentials  
✔ Secrets stored in AWS Secrets Manager  
✔ Principle of least privilege  
✔ No DB creds in repo  
✔ No public exposure of backend/DB  

---

## 📝 Documentation Included

- `architecture.md` – component and traffic flow details
- `dr-strategy.md` – failover and recovery process
- `runbooks.md` – operational procedures and scripts

---

## ✅ Intended Use Cases

portfolio / resume showcase  
learning CI/CD at enterprise level  
AWS DevOps demonstration  
infrastructure automation practice  
disaster recovery architecture example  

---

## 📌 Future Enhancements (optional)

- canary or blue-green deployments  
- SBOM + image signing  
- observability stack (CloudWatch / Grafana / X-Ray)  
- cost-optimized standby region scaling  
- GitOps controllers (ArgoCD / Flux)  

---

## 🧭 Status

✅ Repository structure scaffolded  
⬜ sample frontend  
⬜ sample backend  
⬜ CI pipeline config  
⬜ CD pipeline config  
⬜ Terraform modules  
⬜ DR automation scripts  


---

