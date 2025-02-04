terraform {
  source = "../../../../../../tf-moduls/nginx_service_task"
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
  config_path = "../../infrastructure/0-vpc" # Path to the Security Group Terragrunt configuration
}

dependency "sg" {
  config_path = "../../infrastructure/1-securitygroup" # Path to the Security Group Terragrunt configuration
}

dependency "nlb" {
  config_path = "../../infrastructure/5-nlb" # Path to the ASG Terragrunt configuration
}


dependency "ecs" {
  config_path = "../../infrastructure/6-ecs" # Path to the Security Group Terragrunt configuration
}

inputs = {
  task_family = "nginx-service-task"
  nginx_image = "nginx:latest"
  log_group_name = "/ecs/my-app/logs"
  cwagent_config_path = "/var/log/myapp/*.log"
  region = local.region
  cluster_id = dependency.ecs.outputs.cluster_id
  service_name = "nginx-service"
  desired_count = 1
  subnets = dependency.vpc.outputs.public_subnet_ids
  security_groups = [dependency.sg.outputs.ecs_sg_id]
  assign_public_ip = true
  target_group_arns = dependency.nlb.outputs.target_group_arns
}