variable "app_name" {}
variable "backend_image" {}
variable "backend_task_role_arn" {}
variable "db_host" {}
variable "db_user" {}
variable "db_name" {}
variable "db_password_arn" {}

variable "backend_desired_count" {
  default = 2
}

variable "private_subnets" {
  type = list(string)
}

variable "backend_sg_id" {}
variable "backend_tg_arn" {}
variable "backend_tg_listener_arn" {}
