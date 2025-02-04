
# Role name variable
variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

# List of predefined AWS managed policies
variable "policies" {
  description = "List of default IAM policies to attach"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    "Environment" = "dev"
    "Owner"       = "admin"
  }
}