variable "environment" {
  type = string
}

variable "ami_id" {
  type     = string
  default  = null
  nullable = true
}

variable "public_subnets" {
  type = list(string)
}

variable "private_app_subnets" {
  type = list(string)
}

variable "bastion_sg_id" {
  type = string
}

variable "web_sg_id" {
  type = string
}

variable "app_sg_id" {
  type = string
}

variable "bastion_key_name" {
  type = string
}

variable "web_key_name" {
  type = string
}

variable "app_key_name" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "web_instance_type" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "web_target_group_arn" {
  type = string
}

variable "app_target_group_arn" {
  type = string
}

variable "web_asg_min" {
  type = number
}

variable "web_asg_desired" {
  type = number
}

variable "web_asg_max" {
  type = number
}

variable "app_asg_min" {
  type = number
}

variable "app_asg_desired" {
  type = number
}

variable "app_asg_max" {
  type = number
}

variable "scaling_cpu_target" {
  type = number
}
