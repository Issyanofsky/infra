terraform {
  source = "../../../../../../tf-moduls/ec2_template"
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

dependency "iam_role" {
  config_path = "../2-iam_role" # Path to the VPC Terragrunt configuration
}

dependency "sg" {
  config_path = "../1-securitygroup" # Path to the VPC Terragrunt configuration
}

inputs = {
  template_name             = "${local.env_vars.project}-${local.env}-ecs-template"
  image_id                  = "ami-0342fb9adde85ee7b" # ami-0df8c184d5f6ae949
  instance_type             = "t2.micro"
  vpc_security_group_ids    = [dependency.sg.outputs.ecs_sg_id]
  iam_instance_profile_name = dependency.iam_role.outputs.iam_instance_profile_name
  volume_size               = 30
  volume_type               = "gp3"
  security_group            = dependency.sg.outputs.ecs_sg_id
  ecs_cluster_name          = "${local.env_vars.cluster_name}"
  tags                      = local.merged_tags

}