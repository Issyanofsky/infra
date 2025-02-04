variable "nlb_name" {
  description = "NLB name"
  type        = string
  default     = "ecs-nlb"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where NLB should be placed"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to be associated with the NLB"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the NLB"
  type        = map(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the NLB"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing for the NLB"
  type        = bool
  default     = true
}

variable "drop_invalid_header_fields" {
  description = "Enable dropping of invalid header fields"
  type        = bool
  default     = true
}

variable "listeners" {
  description = "A list of listeners with protocols, ports, and container ports"
  type = list(object({
    protocol       = string
    port           = number
    container_port = number
  }))
}

variable "asg_name" {
  description = "The Name of the existing Auto Scaling Group"
  type        = string
}

#variable "asg_instance_ids" {
#  description = "List of EC2 instance IDs in the Auto Scaling Group"
#  type        = list(string)
#}
