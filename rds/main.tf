resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = var.private_rds_subnets

  tags = {
    Name = "${var.environment}-rds-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier = var.db_identifier

  engine         = "mysql"
  engine_version = "8.0"

  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible = false
  multi_az            = var.multi_az

  backup_retention_period = 7
  deletion_protection     = false
  skip_final_snapshot     = true

  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.environment}-mysql"
    Tier = "database"
  }
}
