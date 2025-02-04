variable "region" {
  type        = string
  description = "ECS Task family name"
}

variable "task_family" {
  type        = string
  description = "ECS Task family name"
}

variable "nginx_image" {
  type        = string
  description = "Docker image for Nginx"
}

variable "log_group_name" {
  type        = string
  description = "CloudWatch Log Group name"
}

variable "cwagent_config_path" {
  type        = string
  description = "Path to CloudWatch agent configuration file"
}

variable "cluster_id" {
  type        = string
  description = "ECS Cluster ID"
}

variable "service_name" {
  type        = string
  description = "ECS Service name"
}

variable "desired_count" {
  type        = number
  description = "Desired number of ECS tasks"
  default     = 1
}

variable "subnets" {
  type        = list(string)
  description = "Subnets for the ECS service"
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups for the ECS service"
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign a public IP to the ECS tasks"
  default     = true
}

variable "target_group_arns" {
  type        = list(string)
  description = "Target Group ARN for the NLB"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {} 
}