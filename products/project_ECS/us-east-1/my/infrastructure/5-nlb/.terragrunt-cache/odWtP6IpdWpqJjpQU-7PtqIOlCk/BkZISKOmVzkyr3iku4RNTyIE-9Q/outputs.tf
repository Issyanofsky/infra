output "ecs_sg_id" {
  description = "The ID of the ECS Security Group."
  value       = aws_security_group.ecs_sg.id
}
