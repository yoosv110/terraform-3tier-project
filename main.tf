module "vpc" {
  source = "./vpc"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnets       = var.public_subnets
  private_app_subnets  = var.private_app_subnets
  private_rds_subnets  = var.private_rds_subnets
  environment          = var.environment
}

module "security" {
  source = "./security"

  vpc_id           = module.vpc.vpc_id
  environment      = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "alb" {
  source = "./alb"

  vpc_id                   = module.vpc.vpc_id
  public_subnets           = module.vpc.public_subnet_ids
  private_app_subnets      = module.vpc.private_app_subnet_ids
  external_alb_sg_id       = module.security.external_alb_sg_id
  internal_alb_sg_id       = module.security.internal_alb_sg_id
  environment              = var.environment

  enable_https             = var.enable_https
  ssl_certificate_arn      = var.ssl_certificate_arn
  create_route53_record    = var.create_route53_record
  route53_zone_id          = var.route53_zone_id
  domain_name              = var.domain_name
}

module "compute" {
  source = "./compute"

  environment              = var.environment
  ami_id                   = var.ami_id

  public_subnets           = module.vpc.public_subnet_ids
  private_app_subnets      = module.vpc.private_app_subnet_ids

  bastion_sg_id            = module.security.bastion_sg_id
  web_sg_id                = module.security.web_sg_id
  app_sg_id                = module.security.app_sg_id

  bastion_key_name         = var.ssh_key_name_bastion
  web_key_name             = var.ssh_key_name_web
  app_key_name             = var.ssh_key_name_app

  bastion_instance_type    = var.bastion_instance_type
  web_instance_type        = var.web_instance_type
  app_instance_type        = var.app_instance_type

  web_target_group_arn     = module.alb.web_target_group_arn
  app_target_group_arn     = module.alb.app_target_group_arn

  web_asg_min              = var.web_asg_min
  web_asg_desired          = var.web_asg_desired
  web_asg_max              = var.web_asg_max

  app_asg_min              = var.app_asg_min
  app_asg_desired          = var.app_asg_desired
  app_asg_max              = var.app_asg_max

  scaling_cpu_target       = var.scaling_cpu_target
}

module "rds" {
  source = "./rds"

  environment              = var.environment
  private_rds_subnets      = module.vpc.private_rds_subnet_ids
  rds_sg_id                = module.security.rds_sg_id

  db_identifier            = var.db_identifier
  db_name                  = var.db_name
  db_username              = var.db_username
  db_password              = var.db_password
  db_instance_class        = var.db_instance_class
  db_allocated_storage     = var.db_allocated_storage
  db_max_allocated_storage = var.db_max_allocated_storage
  multi_az                 = var.rds_multi_az
}

module "waf" {
  count  = var.enable_waf ? 1 : 0
  source = "./waf"

  environment = var.environment
  alb_arn     = module.alb.external_alb_arn
}
