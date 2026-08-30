variable "vpc_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "allowed_ssh_cidr" {
  description = "Administrator public IP/32"
  type        = string
}
