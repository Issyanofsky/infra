terraform {
  backend "local" {}
}

# IAM Role Resource
resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Instance Profile Resource (this links the role to EC2 instances)
resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.this.name
}

# Attach the policies to the IAM role
resource "aws_iam_role_policy_attachment" "policies" {
  for_each = toset(var.policies)

  role       = aws_iam_role.this.name
  policy_arn = each.value # Use the ARN from the fetched policy
}
