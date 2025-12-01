variable "app_name" {
  type        = string
  description = "Application name used for resource naming (eg. 'project2')."
}

variable "vpc_id" {
  type        = string
  description = "VPC id where the ALB and target group will be created."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB (must be public subnets)."
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach to the ALB (ALB SGs)."
  default     = []
}

variable "listener_port" {
  type        = number
  description = "Port the ALB listener will listen on."
  default     = 80
}

variable "listener_protocol" {
  type        = string
  description = "Protocol for the ALB listener."
  default     = "HTTP"
}

variable "target_port" {
  type        = number
  description = "Port on the container the target group forwards to."
  default     = 3000
}

variable "target_protocol" {
  type        = string
  description = "Protocol used by the target group."
  default     = "HTTP"
}

variable "target_path" {
  type        = string
  description = "Health check path for the target group."
  default     = "/"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to resources."
  default     = {}
}
