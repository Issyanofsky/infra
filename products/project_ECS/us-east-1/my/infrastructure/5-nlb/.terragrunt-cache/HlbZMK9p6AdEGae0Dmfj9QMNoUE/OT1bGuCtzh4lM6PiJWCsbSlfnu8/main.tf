terraform {
  backend "local" {}
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = var.template_name
  image_id      = var.image_id      # Parametrized AMI ID for flexibility
  instance_type = var.instance_type # Parametrized instance type
  # key_name             = var.key_name            # Parametrized key name
  # vpc_security_group_ids = var.vpc_security_group_ids # Parametrized security group IDs

  iam_instance_profile {
    name = var.iam_instance_profile_name # Parametrized IAM instance profile name
  }
  network_interfaces {
    device_index = 0
    associate_public_ip_address = true
    security_groups = [var.security_group]
    delete_on_termination = "true"

  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  # User Data to configure ECS agent and register EC2 instance with the ECS cluster
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${var.ecs_cluster_name}" > /etc/ecs/ecs.config
    start ecs
  EOF
  )

  tags = merge(
    var.tags,
    {
      resource_type = "instance"
    }
  )
  # user_data = filebase64("${path.module}/ecs.sh") # Ensure ecs.sh exists
}
