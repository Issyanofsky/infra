output "nlb_arn" {
  description = "The ARN of the Network Load Balancer"
  value       = aws_lb.nlb.arn
}

output "nlb_dns_name" {
  description = "The DNS name of the Network Load Balancer"
  value       = aws_lb.nlb.dns_name
}

output "target_group_arns" {
  description = "The ARNs of the target groups"
  value       = [for tg in aws_lb_target_group.target_groups : tg.arn]
}

output "listener_arns" {
  description = "The ARNs of the listeners"
  value       = [for listener in aws_lb_listener.listeners : listener.arn]
}
