# Auto Scaling Group (ASG) resource
resource "aws_autoscaling_group" "ecs_asg" {
  name                = var.asg_name
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  # health_check_type                 = "EC2"
  # health_check_grace_period         = 300
  # force_delete                      = true
  # wait_for_capacity_timeout         = "0"

  #lifecycle {
  #  create_before_destroy = true
  # }

  launch_template {
    id      = var.template_id
    version = "$Latest"
  }

  #protect_from_scale_in = true

  # Merging the user-defined tags and default tags
  dynamic "tag" {
    for_each = merge(
      var.tags, # These are the tags passed as a variable
      {
        "Name"             = "ECS-ASG"
        "AmazonECSManaged" = "true"
        "ManagedBy"        = "Terraform"
      }
    )

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}