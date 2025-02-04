variable "cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "asg_arn" {
  description = "The ARN of the Auto Scaling Group (ASG) that will be used as a capacity provider."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the ECS cluster."
  type        = map(string)
  default     = {}
}
