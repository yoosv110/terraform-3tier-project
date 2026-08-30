variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_app_subnets" {
  type = list(string)
}

variable "external_alb_sg_id" {
  type = string
}

variable "internal_alb_sg_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "enable_https" {
  type = bool
}

variable "ssl_certificate_arn" {
  type     = string
  default  = null
  nullable = true
}

variable "create_route53_record" {
  type = bool
}

variable "route53_zone_id" {
  type     = string
  default  = null
  nullable = true
}

variable "domain_name" {
  type     = string
  default  = null
  nullable = true
}
