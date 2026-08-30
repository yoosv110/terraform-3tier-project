variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Two availability zones"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "availability_zones must contain exactly two AZs."
  }
}

variable "public_subnets" {
  description = "Public subnet CIDRs for Web/ALB/NAT/Bastion"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.4.0/24"]
}

variable "private_app_subnets" {
  description = "Private Application subnet CIDRs"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.5.0/24"]
}

variable "private_rds_subnets" {
  description = "Private RDS subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.6.0/24"]
}

variable "allowed_ssh_cidr" {
  description = "Administrator public IP CIDR allowed to SSH to Bastion"
  type        = string
}

variable "ami_id" {
  description = "Optional AMI ID. null uses the latest Amazon Linux 2023 x86_64 AMI."
  type        = string
  default     = null
  nullable    = true
}

variable "ssh_key_name_bastion" {
  description = "Existing EC2 key pair name for Bastion"
  type        = string
}

variable "ssh_key_name_web" {
  description = "Existing EC2 key pair name for Web ASG instances"
  type        = string
}

variable "ssh_key_name_app" {
  description = "Existing EC2 key pair name for App ASG instances"
  type        = string
}

variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "web_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "web_asg_min" {
  type    = number
  default = 2
}

variable "web_asg_desired" {
  type    = number
  default = 2
}

variable "web_asg_max" {
  type    = number
  default = 4
}

variable "app_asg_min" {
  type    = number
  default = 2
}

variable "app_asg_desired" {
  type    = number
  default = 2
}

variable "app_asg_max" {
  type    = number
  default = 4
}

variable "scaling_cpu_target" {
  description = "Target average CPU utilization percentage for ASG target tracking"
  type        = number
  default     = 60
}

variable "enable_https" {
  description = "Enable HTTPS listener on the external ALB"
  type        = bool
  default     = false
}

variable "ssl_certificate_arn" {
  description = "ACM certificate ARN. Required when enable_https=true"
  type        = string
  default     = null
  nullable    = true
}

variable "create_route53_record" {
  description = "Create an A alias record pointing to the external ALB"
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
  default     = null
  nullable    = true
}

variable "domain_name" {
  description = "DNS name for Route53 record"
  type        = string
  default     = null
  nullable    = true
}

variable "db_identifier" {
  type    = string
  default = "three-tier-mysql"
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  description = "RDS master password. Do not commit a real password to Git."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_max_allocated_storage" {
  type    = number
  default = 100
}

variable "rds_multi_az" {
  type    = bool
  default = true
}

variable "enable_waf" {
  description = "Create AWS WAF and associate it with the external ALB"
  type        = bool
  default     = false
}
