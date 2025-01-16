terraform {
  source = find_in_parent_folders("tf-moduls/ecs")
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
  mock_outputs = {
    vpc_id             = "some-id"
    public_subnet_ids  = ["10.0.101.0/16", "10.0.102,0/16"]
    private_subnet_ids = ["10.0.1.0/16", "10.0.2,0/16"]
  }

}

inputs = {

  project_name       = local.env_vars.project
  env                = local.env_vars.env
  region             = "${local.region}"
  cluster_name       = "${local.env_vars.project}-${local.env_vars.short_env}-ecs-cluster"
  vpc_cidr           = "10.0.0.0/16"
  azs                = ["${local.region}a", "${local.region}b"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]     # dependency.vpc.outputs.private_subnets
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"] # dependency.vpc.outputs.public_subnets
  ecs_security_group = "ecs-${local.env_vars.env}-sg"
  ec2_ami_id            = "ami-079cb33ef719a7b78" # "ami-0c55b159cbfafe1f0"
  ec2_instance_type  = "t2.micro"
  ec2_instance_count = 2
  fargate_task_count = 1
  container_image    = "nginx"
  ec2_task_count     = 2

  tags = local.merged_tags
}
