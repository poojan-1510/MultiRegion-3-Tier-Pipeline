variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "app_name" {
  type = string
}

variable "source_dir" {
  type = string
}

variable "project_name" {
  type = string
}

variable "account_id" {
  type = string
}
