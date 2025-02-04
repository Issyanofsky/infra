resource "aws_lb" "nlb" {
  name                             = var.nlb_name
  internal                         = false
  load_balancer_type               = "network"
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  security_groups                  = var.security_group_ids
  subnets                          = var.subnet_ids
  tags                             = var.tags
}

# Create Target Groups for each listener with protocol HTTP or HTTPS (for Layer 7)
resource "aws_lb_target_group" "target_groups" {
  for_each = { for idx, listener in var.listeners : "${listener.protocol}-${listener.port}" => listener }

  name     = "${each.value.protocol}-${each.value.port}-tg"
  port     = each.value.container_port
  protocol = "TCP"

  vpc_id = var.vpc_id

  health_check {
    interval            = 30
    port                = each.value.container_port
    protocol            = "TCP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = var.tags
}

# Create Listeners for the NLB based on the variable `listeners`
resource "aws_lb_listener" "listeners" {
  for_each = { for idx, listener in var.listeners : "${listener.protocol}-${listener.port}" => listener }

  load_balancer_arn = aws_lb.nlb.arn
  protocol          = "TCP"
  port              = each.value.port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_groups[each.key].arn
  }

  tags = var.tags
}

# Target Group attachment to ASG instances (ensure that you pass ASG instances)
#resource "aws_lb_target_group_attachment" "asg_attachment" {
#  for_each = { for idx, listener in var.listeners : "${listener.protocol}-${listener.port}" => listener }

#  target_group_arn = aws_lb_target_group.target_groups[each.key].arn
# target_id        = var.asg_instance_ids[*]
#  port             = each.value.container_port
#}