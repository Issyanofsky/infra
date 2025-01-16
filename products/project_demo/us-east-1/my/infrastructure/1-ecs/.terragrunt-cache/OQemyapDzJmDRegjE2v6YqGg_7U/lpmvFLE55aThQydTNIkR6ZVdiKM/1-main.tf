# Create the ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.env}-ecs-cluster"
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.project_name}-${var.env}-ecs-instance-role"

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

# IAM Role for Fargate tasks
resource "aws_iam_role" "ecs_fargate_role" {
  name = "${var.project_name}-${var.env}-ecs-fargate-role"

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

# Security Group for ECS (both EC2 and Fargate)
resource "aws_security_group" "ecs_security_group" {
  name        = "${var.project_name}-${var.env}-ecs-sg"
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

# ECS EC2 Instance Role & Instance Profile
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.project_name}-${var.env}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

# EC2 Instances (worker nodes) for ECS Cluster
resource "aws_instance" "ecs_instance" {
  count             = var.ec2_instance_count
  ami               = var.ec2_ami_id
  instance_type     = var.ec2_instance_type
  subnet_id         = element(var.private_subnets, count.index)
  # key_name          = var.key_name
  security_groups   = [aws_security_group.ecs_security_group.name]
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
}

# Fargate Task Definitions
resource "aws_ecs_task_definition" "fargate_task_definition" {
  family                   = "${var.project_name}-${var.env}-fargate-task-definition"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_fargate_role.arn
  task_role_arn            = aws_iam_role.ecs_fargate_role.arn
  container_definitions    = jsonencode([{
    name      = "fargate-container"
    image     = var.container_image
    cpu       = 256
    memory    = 512
    essential = true
  }])
}

# EC2 Task Definition for ECS EC2 Instances
resource "aws_ecs_task_definition" "ec2_task_definition" {
  family                   = "${var.project_name}-${var.env}-ec2-task-definition"
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.ecs_instance_role.arn
  task_role_arn            = aws_iam_role.ecs_instance_role.arn
  container_definitions    = jsonencode([{
    name      = "ec2-container"
    image     = var.container_image
    cpu       = 256
    memory    = 512
    essential = true
  }])
}

# ECS Service for EC2 instances
resource "aws_ecs_service" "ec2_service" {
  name            = "${var.project_name}"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ec2_task_definition.arn
  desired_count   = var.ec2_task_count
  launch_type     = "EC2"
  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = false
  }
}

# ECS Service for Fargate
resource "aws_ecs_service" "fargate_service" {
  name            = "${var.project_name}-${var.env}-fargate-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.fargate_task_definition.arn
  desired_count   = var.fargate_task_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = false
  }
}

# Load Balancer for ECS EC2 Instances (Optional but recommended)
resource "aws_lb" "ecs_lb" {
  name               = "${var.project_name}-${var.env}-ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_security_group.id]
  subnets            = var.public_subnets
}

# Listener for Load Balancer
resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = 200
      message_body = "Hello from ECS!"
      content_type = "text/plain"
    }
  }
}

# Auto Scaling for ECS EC2 Instances
resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity     = var.ec2_task_count
  max_size             = var.ec2_task_count + 2
  min_size             = var.ec2_task_count
  vpc_zone_identifier  = var.private_subnets
  launch_configuration = aws_launch_configuration.ecs_launch_config.id
}

# Launch Configuration for EC2 Instances in Auto Scaling Group
resource "aws_launch_configuration" "ecs_launch_config" {
  name          = "${var.project_name}-${var.env}-ecs-launch-config"
  image_id      = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  security_groups = [aws_security_group.ecs_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
}

