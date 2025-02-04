output "autoscaling_group_id" {
  description = "The ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.ecs_asg.id
}

output "autoscaling_group_arn" {
  description = "The ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.ecs_asg.arn
}

output "asg_name" {
  value       = aws_autoscaling_group.ecs_asg.name
  description = "The name of the Auto Scaling Group"
}
