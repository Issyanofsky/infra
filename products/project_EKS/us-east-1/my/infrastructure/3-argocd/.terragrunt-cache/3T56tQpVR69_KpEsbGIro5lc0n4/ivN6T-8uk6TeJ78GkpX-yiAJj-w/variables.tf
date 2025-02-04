variable "chart_version" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "hosts" {
  type        = list(string)
  description = "The hostnames for the ingress"
  default     = ["argocd.dev.private.mydomain.com"]
}