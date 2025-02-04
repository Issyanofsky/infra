variable "template_name" {
  description = "launch template name"
  type        = string
  default     = "ecs-template"
}

variable "ecs_cluster_name" {
  description = "launch template name"
  type        = string
  default     = "ecs-cluster"
}

variable "security_group" {
  description = "security group IDs"
  type        = string

}

variable "image_id" {
  description = "AMI ID for the launch template"
  type        = string
  default     = "ami-0df8c184d5f6ae949"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

#variable "key_name" {
#  description = "SSH key name for EC2 instances"
#  type        = string
#}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "volume_size" {
  description = "Volume size for the root EBS disk"
  type        = number
  default     = 30 # Default to 30GB if not provided
}

variable "volume_type" {
  description = "Volume type for the root EBS disk"
  type        = string
  default     = "gp3"
}

variable "tags" {
  description = "Tags to assign to the launch template"
  type        = map(string)

}

