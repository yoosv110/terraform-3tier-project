output "vpc_id" {
  value = module.vpc.vpc_id
}

output "external_alb_dns_name" {
  value = module.alb.external_alb_dns_name
}

output "internal_alb_dns_name" {
  value = module.alb.internal_alb_dns_name
}

output "bastion_public_ip" {
  value = module.compute.bastion_public_ip
}

output "web_asg_name" {
  value = module.compute.web_asg_name
}

output "app_asg_name" {
  value = module.compute.app_asg_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "waf_arn" {
  value = var.enable_waf ? module.waf[0].web_acl_arn : null
}
