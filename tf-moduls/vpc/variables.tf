variable "aws_region" {
  description = "The AWS region"
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment name"
  default     = "dev"
}

variable "project" {
  description = "The environment name"
  default     = "projectx"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block of the vpc"

}

variable "public_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "CIDR block for Private Subnet"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    "Environment" = "dev"
    "Owner"       = "admin"
  }
}