variable "app_name" {
  type        = string
  description = "Application name."
}

variable "cluster_name" {
  type    = string
  default = null
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 3000
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "environment" {
  type    = map(string)
  default = {}
}

variable "target_group_arn" {
  type = string
}

# --- NEW: IAM roles provided by IAM module ---
variable "execution_role_arn" {
  type        = string
  description = "Task execution role from IAM module."
}

variable "task_role_arn" {
  type        = string
  description = "Task role from IAM module."
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
