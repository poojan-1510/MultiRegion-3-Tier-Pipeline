variable "app_name" {
  type        = string
  description = "Application name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where SGs will be created"
}

variable "container_port" {
  type        = number
  description = "Port ECS container listens on"
}

