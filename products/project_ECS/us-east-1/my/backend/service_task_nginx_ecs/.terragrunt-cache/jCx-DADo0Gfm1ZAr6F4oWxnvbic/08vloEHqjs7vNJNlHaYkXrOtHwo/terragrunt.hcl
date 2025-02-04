terraform {
  source = "../../../../../../tf-moduls/vpc"
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

inputs = {
  aws_region  = local.region
  project     = local.env_vars.project
  environment = local.env
  vpc_cidr    = "10.0.0.0/16"

  public_subnets_cidr  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]

  tags = local.merged_tags
}
