# terragrunt.hcl for ECS Cluster with EC2 and Fargate

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs.git?ref=v5.12.0"
}

# Local variables to read configurations from parent folders
locals {
  env_vars    = (read_terragrunt_config(find_in_parent_folders("env.hcl"))).locals
  common_tags = (read_terragrunt_config(find_in_parent_folders("common_tags.hcl"))).locals
  merged_tags = merge(local.env_vars, local.common_tags.common_tags)
  env         = local.env_vars.short_env
  region      = (read_terragrunt_config(find_in_parent_folders("region.hcl"))).locals.aws_region
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../0-vpc" # Path to the VPC Terragrunt configuration
}

inputs = {
  # VPC and Subnet configuration
  vpc_id             = dependency.vpc.outputs.vpc_id
  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  region             = local.region

  # ECS Cluster Configuration
  cluster_name         = "${local.env_vars.project}-${local.env}-ecs-cluster"
  enable_ec2_instances = true
  enable_fargate       = true
  ec2_instance_type    = "t2.micro" # EC2 instance type for EC2 worker nodes (adjust as needed)

  # IAM Role for EC2 instances in ECS cluster
  ecs_instance_role = aws_iam_role.ecs_instance_role.arn

  # Fargate Task Definition (Task roles, container definitions etc.)
  task_definition_name = "${local.env_vars.project}-${local.env}-fargate-task"
  container_image      = "your-container-image-url" # Container image (can be ECR or DockerHub)

  # ECS Service Configuration
  fargate_task_count = 1 # Number of Fargate tasks
  ec2_task_count     = 2 # Number of EC2 instances running in ECS

  # Security Group Configuration
  ecs_security_group_id = aws_security_group.ecs_security_group.id

  # Tags
  tags = local.merged_tags
}

# IAM Roles for ECS EC2 Instances and Fargate Tasks
resource "aws_iam_role" "ecs_instance_role" {
  name = "${local.env_vars.project}-${local.env}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role" "ecs_fargate_role" {
  name = "${local.env_vars.project}-${local.env}-ecs-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      },
    ]
  })
}

# Security Group for ECS Instances
resource "aws_security_group" "ecs_security_group" {
  name        = "${local.env_vars.project}-${local.env}-ecs-sg"
  description = "Allow inbound access to ECS instances and tasks"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Cluster Setup
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.env_vars.project}-${local.env}-ecs-cluster"
}

# ECS Service for EC2 instances
resource "aws_ecs_service" "ec2_service" {
  name            = "${local.env_vars.project}-${local.env}-ec2-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ec2_task_definition.arn
  desired_count   = var.ec2_task_count
  launch_type     = "EC2"
}

# ECS Service for Fargate
resource "aws_ecs_service" "fargate_service" {
  name            = "${local.env_vars.project}-${local.env}-fargate-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.fargate_task_definition.arn
  desired_count   = var.fargate_task_count
  launch_type     = "FARGATE"
}

# EC2 Task Definition for ECS EC2 Instances
resource "aws_ecs_task_definition" "ec2_task_definition" {
  family             = "${local.env_vars.project}-${local.env}-ec2-task-definition"
  network_mode       = "bridge"
  execution_role_arn = aws_iam_role.ecs_instance_role.arn
  task_role_arn      = aws_iam_role.ecs_instance_role.arn
  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = var.container_image
      cpu       = 256
      memory    = 512
      essential = true
    }
  ])
}

# Fargate Task Definition
resource "aws_ecs_task_definition" "fargate_task_definition" {
  family             = "${local.env_vars.project}-${local.env}-fargate-task-definition"
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_fargate_role.arn
  task_role_arn      = aws_iam_role.ecs_fargate_role.arn
  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = var.container_image
      cpu       = 256
      memory    = 512
      essential = true
    }
  ])
}
