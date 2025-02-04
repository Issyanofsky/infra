variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
  default     = "my-ecs-auto-scaling-group" # You can change this to whatever you like
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the Auto Scaling Group"
  type        = list(string)
}

variable "desired_capacity" {
  description = "The desired capacity for the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum size for the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum size for the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "template_id" {
  description = "A list of subnet IDs for the Auto Scaling Group"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the launch template"
  type        = map(string)

}
