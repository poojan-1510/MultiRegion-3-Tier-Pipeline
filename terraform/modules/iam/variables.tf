variable "project_name" {
  type = string
}

variable "account_id" {
  type = string
}

# Keep for compatibility
variable "enable_task_role" {
  type    = bool
  default = true
}

# Optional tags
variable "tags" {
  type    = map(string)
  default = {}
}
variable "app_name" {
  type        = string
  description = "Application name"
}

variable "github_org" {
  type        = string
  description = "GitHub organization for OIDC trust"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository for OIDC trust"
}
