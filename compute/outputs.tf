output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "web_launch_template_id" {
  value = aws_launch_template.web.id
}

output "app_launch_template_id" {
  value = aws_launch_template.app.id
}

output "web_asg_name" {
  value = aws_autoscaling_group.web.name
}

output "app_asg_name" {
  value = aws_autoscaling_group.app.name
}
