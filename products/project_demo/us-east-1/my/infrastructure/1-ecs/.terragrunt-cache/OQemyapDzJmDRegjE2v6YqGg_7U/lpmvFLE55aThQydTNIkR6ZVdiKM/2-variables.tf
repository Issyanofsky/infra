variable "project_name" {
  description = "The project name"
  type        = string
}

variable "env" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "container_image" {
  description = "The Docker container image URL"
  type        = string
}

variable "ec2_instance_type" {
  description = "The EC2 instance type for ECS worker nodes"
  type        = string
  default     = "t2.micro"
}

variable "ec2_ami_id" {
  description = "The AMI ID for ECS EC2 worker nodes"
  type        = string
}

variable "ec2_instance_count" {
  description = "The number of EC2 worker nodes in the ECS cluster"
  type        = number
  default     = 2
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)

  # Default value for the private subnets
  default     = [
    "10.0.1.0/16",  # Example subnet 1
    "10.0.2.0/16"   # Example subnet 2
  ]
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
   # Default value for the public subnets
  default     = [
    "10.0.101.0/16",  # Example subnet 1
    "10.0.102.0/16"   # Example subnet 2
  ]
}

variable "ecs_security_group" {
  description = "The ECS security group"
  type        = string
}

variable "fargate_task_count" {
  description = "The number of Fargate tasks to run"
  type        = number
  default     = 1
}

variable "ec2_task_count" {
  description = "The number of EC2 tasks to run"
  type        = number
  default     = 2
}