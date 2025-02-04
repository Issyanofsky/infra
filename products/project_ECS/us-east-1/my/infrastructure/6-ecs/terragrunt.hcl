terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs.git?ref=v5.12.0"
}

locals {
  env_vars    = (read_terragrunt_config(find_in_parent_folders("env.hcl"))).locals
  common_tags = (read_terragrunt_config(find_in_parent_folders("common_tags.hcl"))).locals
  merged_tags = merge(local.env_vars, local.common_tags.common_tags)
  env         = local.env_vars.short_env
  region      = (read_terragrunt_config(find_in_parent_folders("region.hcl"))).locals.aws_region
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}


dependency "iam_role" {
  config_path = "../2-iam_role" # Path to the VPC Terragrunt configuration
}

dependency "sg" {
  config_path = "../1-securitygroup" # Path to the VPC Terragrunt configuration
}

dependency "asg" {
  config_path = "../4-asg" # Path to the VPC Terragrunt configuration
}

inputs = {

  cluster_name = "${local.env_vars.cluster_name}"

  # Define EC2 capacity provider (default)
  autoscaling_capacity_providers = {
    EC2 = {
      auto_scaling_group_arn = dependency.asg.outputs.autoscaling_group_arn
      managed_scaling = {
        maximum_scaling_step_size = 2
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 1
      }
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
  default_capacity_provider_use_fargate = false
  # Define Fargate capacity provider (optional)
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  # ECS Cluster Configuration
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }
  cluster_settings = {
    "name"  = "containerInsights"
    "value" = "disabled"
  }

  # Define the Launch Template for EC2 instances
  launch_template = {
    name          = "ecs-instance-launch-template"
    version       = 1
    ec2_ami_id    = "ami-0df8c184d5f6ae949"
    instance_type = "t2.micro" # Specify your instance type
    # key_name = "ecs-key"           # Your EC2 key pair name
    network_interfaces = {
      device_index                = 0
      associate_public_ip_address = true
      security_groups             = [dependency.sg.outputs.ecs_sg_id]
      delete_on_termination       = "true"
    }

    user_data = <<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${local.env_vars.cluster_name} >> /etc/ecs/ecs.config
    EOF
  }

  tags = local.merged_tags
}
