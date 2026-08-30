data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  selected_ami = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux_2023.id
}

# Bastion remains a single EC2 instance.
resource "aws_instance" "bastion" {
  ami                         = local.selected_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnets[0]
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.bastion_key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "${var.environment}-bastion"
  }
}

# Web Launch Template replaces aws_instance.web1 / aws_instance.web2.
resource "aws_launch_template" "web" {
  name_prefix            = "${var.environment}-web-"
  image_id               = local.selected_ami
  instance_type          = var.web_instance_type
  key_name               = var.web_key_name
  vpc_security_group_ids = [var.web_sg_id]
  update_default_version = true

  user_data = filebase64("${path.module}/web-user-data.sh")

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.environment}-web-asg-instance"
      Tier = "web"
    }
  }

  tags = {
    Name = "${var.environment}-web-launch-template"
  }
}

resource "aws_autoscaling_group" "web" {
  name                      = "${var.environment}-web-asg"
  min_size                  = var.web_asg_min
  desired_capacity          = var.web_asg_desired
  max_size                  = var.web_asg_max
  vpc_zone_identifier       = var.public_subnets
  target_group_arns         = [var.web_target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 180
  default_instance_warmup   = 60

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-web-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "web"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_cpu" {
  name                   = "${var.environment}-web-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.scaling_cpu_target
  }
}

# App Launch Template replaces aws_instance.app1 / aws_instance.app2.
resource "aws_launch_template" "app" {
  name_prefix            = "${var.environment}-app-"
  image_id               = local.selected_ami
  instance_type          = var.app_instance_type
  key_name               = var.app_key_name
  vpc_security_group_ids = [var.app_sg_id]
  update_default_version = true

  user_data = filebase64("${path.module}/app-user-data.sh")

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.environment}-app-asg-instance"
      Tier = "application"
    }
  }

  tags = {
    Name = "${var.environment}-app-launch-template"
  }
}

resource "aws_autoscaling_group" "app" {
  name                      = "${var.environment}-app-asg"
  min_size                  = var.app_asg_min
  desired_capacity          = var.app_asg_desired
  max_size                  = var.app_asg_max
  vpc_zone_identifier       = var.private_app_subnets
  target_group_arns         = [var.app_target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 180
  default_instance_warmup   = 60

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-app-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "application"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "app_cpu" {
  name                   = "${var.environment}-app-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.scaling_cpu_target
  }
}
