variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}


variable "tags" {
  description = "Tags to apply to the ECS cluster."
  type        = map(string)
  default     = {}
}
