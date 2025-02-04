variable "aws_region" {
  description = "The AWS region"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created."
  type        = string
}

variable "ecs_sg_name" {
  description = "The name of the security group for ECS tasks."

}

variable "http_port" {
  description = "The port for HTTP access (default is 80)."
  type        = number
  default     = 80
}

variable "https_port" {
  description = "The port for HTTPS access (default is 443)."
  type        = number
  default     = 443
}

variable "ecs_ports_start" {
  description = "The starting port for ECS task ports (default is 5000)."
  type        = number
  default     = 5000
}

variable "ecs_ports_end" {
  description = "The ending port for ECS task ports (default is 5100)."
  type        = number
  default     = 5100
}

variable "http_cidr_blocks" {
  description = "The CIDR blocks for HTTP access (port 80)."
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default allows all IPs
}

variable "https_cidr_blocks" {
  description = "The CIDR blocks for HTTPS access (port 443)."
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default allows all IPs
}

variable "ecs_ports_cidr_blocks" {
  description = "The CIDR blocks for ECS task ports (5000-5100)."
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default allows all IPs
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    "Environment" = "dev"
    "Owner"       = "admin"
  }
}