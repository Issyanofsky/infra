output "launch_template_id" {
  description = "ID of the created ECS Launch Template"
  value       = aws_launch_template.ecs_lt.id
}

output "launch_template_name" {
  description = "Name of the created ECS Launch Template"
  value       = aws_launch_template.ecs_lt.name
}
