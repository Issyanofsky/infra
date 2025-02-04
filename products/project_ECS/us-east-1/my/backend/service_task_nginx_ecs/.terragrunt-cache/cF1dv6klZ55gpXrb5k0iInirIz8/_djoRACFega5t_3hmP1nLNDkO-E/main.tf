# ECS Task Definition
resource "aws_ecs_task_definition" "nginx_with_cw_agent" {
  family                   = var.task_family
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  tags = var.tags
  
  container_definitions = jsonencode([
    {
      name        = "nginx"
      image       = var.nginx_image
      essential   = true
      memory      = 256
      cpu         = 256
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "nginx"
        }
      }
    },
    {
      name        = "cloudwatch-agent"
      image       = "amazon/cloudwatch-agent:latest"
      essential   = false
      memory      = 128
      cpu         = 128
      environment = [
        {
          name  = "CW_AGENT_CONFIG"
          value = "/etc/cwagentconfig.json"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "cwagent-config"
          containerPath = "/etc/cwagentconfig.json"
        }
      ]
    }
  ])

  volume {
    name = "cwagent-config"

#    host {
#      source_path = var.cwagent_config_path
#    }
  }
  
}

# CloudWatch Log Group for Nginx container
resource "aws_cloudwatch_log_group" "nginx_logs" {
  name              = var.log_group_name
  retention_in_days = 7
}

# ECS Service that deploys the task definition
resource "aws_ecs_service" "nginx_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.nginx_with_cw_agent.arn
  desired_count   = var.desired_count
  launch_type     = "EC2"

  #network_configuration {
  #  subnets          = var.subnets
  #  security_groups = var.security_groups
  #  assign_public_ip = var.assign_public_ip
  #}

  load_balancer {
    target_group_arn = var.target_group_arns[1]  # This is the ARN of the target group
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [
    aws_ecs_task_definition.nginx_with_cw_agent
  ]
  tags = var.tags
}
