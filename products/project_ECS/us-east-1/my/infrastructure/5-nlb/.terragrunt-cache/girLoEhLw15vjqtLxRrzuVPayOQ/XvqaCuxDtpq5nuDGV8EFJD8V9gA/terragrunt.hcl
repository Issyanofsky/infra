terraform {
  source = "../../../../../../tf-moduls/nlb"
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
  config_path = "../0-vpc" # Path to the Security Group Terragrunt configuration
}

dependency "sg" {
  config_path = "../1-securitygroup" # Path to the Security Group Terragrunt configuration
}

dependency "asg" {
  config_path = "../4-asg" # Path to the ASG Terragrunt configuration
}


inputs = {
  nlb_name                         = "${local.env_vars.project}-${local.env}-nlb"
  vpc_id                           = dependency.vpc.outputs.aws_vpc_id
  subnet_ids                       = dependency.vpc.outputs.public_subnet_ids
  security_group_ids               = [dependency.sg.outputs.ecs_sg_id]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  drop_invalid_header_fields       = true
  listeners = [
    {
      protocol       = "TCP"
      port           = 80
      container_port = 80
    },
    {
      protocol       = "TCP"
      port           = 443
      container_port = 443
    }
  ]
  asg_name = dependency.asg.outputs.asg_name
  tags   = local.merged_tags
}