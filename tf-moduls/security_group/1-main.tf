
resource "aws_security_group" "ecs_sg" {
  name        = var.ecs_sg_name
  description = "Security Group for ECS tasks"
  vpc_id      = var.vpc_id

  # Inbound rules for HTTP (port 80)
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.http_cidr_blocks
  }

  # Inbound rules for HTTPS (port 443)
  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = var.https_cidr_blocks
  }

  # Inbound rule for ECS task ports (5000-5100)
  ingress {
    from_port   = var.ecs_ports_start
    to_port     = var.ecs_ports_end
    protocol    = "tcp"
    cidr_blocks = var.ecs_ports_cidr_blocks
  }

  # Outbound rule (open to all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = var.ecs_sg_name
    }
  )
}
