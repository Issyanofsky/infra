output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "asg_capacity_provider_name" {
  value = aws_ecs_capacity_provider.asg_capacity_provider.name
}
