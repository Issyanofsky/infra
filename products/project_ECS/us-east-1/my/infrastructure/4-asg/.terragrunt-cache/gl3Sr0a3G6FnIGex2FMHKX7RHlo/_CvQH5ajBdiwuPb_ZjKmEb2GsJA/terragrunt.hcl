terraform {
  source = "../../../../../../tf-moduls/asg"
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

dependency "launch_template" {
  config_path = "../3-ec2template" # Path to the VPC Terragrunt configuration
}


inputs = {
  asg_name         = "${local.env_vars.project}-${local.env}-asg"
  subnet_ids       = dependency.vpc.outputs.public_subnet_ids
  desired_capacity = 1
  max_size         = 2
  min_size         = 1
  template_id      = dependency.launch_template.outputs.launch_template_id

  tags = local.merged_tags
}