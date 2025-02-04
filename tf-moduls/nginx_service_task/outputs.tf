output "task_definition_arn" {
  value = aws_ecs_task_definition.nginx_with_cw_agent.arn
}

output "service_name" {
  value = aws_ecs_service.nginx_service.name
}
