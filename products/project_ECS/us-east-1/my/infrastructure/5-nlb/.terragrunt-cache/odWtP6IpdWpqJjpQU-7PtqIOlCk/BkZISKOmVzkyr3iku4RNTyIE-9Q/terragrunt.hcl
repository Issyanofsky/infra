terraform {
  source = "../../../../../../tf-moduls/security_group"
}

locals {
  env_vars    = (read_terragrunt_config(find_in_parent_folders("env.hcl"))).locals
  common_tags = (read_terragrunt_config(find_in_parent_folders("common_tags.hcl"))).locals
  merged_tags = merge(local.env_vars, local.common_tags.common_tags)
  env         = local.env_vars.short_env
  region      = (read_terragrunt_config(find_in_parent_folders("region.hcl"))).locals.aws_region
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../0-vpc" # Path to the VPC Terragrunt configuration
}

inputs = {
  vpc_id      = dependency.vpc.outputs.aws_vpc_id # Reference the vpc_id output from the VPC module
  ecs_sg_name = "${local.env_vars.project}-${local.env}-sg"

  # Optional, you can override the default ports
  http_port       = 80
  https_port      = 443
  ecs_ports_start = 5000
  ecs_ports_end   = 5100

  # Optional, customize CIDR blocks if needed
  http_cidr_blocks      = ["0.0.0.0/0"]
  https_cidr_blocks     = ["0.0.0.0/0"]
  ecs_ports_cidr_blocks = ["0.0.0.0/0"]

  tags = local.merged_tags
}

