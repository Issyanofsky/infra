terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v20.31.1"
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
  cluster_name                             = "${local.env_vars.cluster_name}"
  cluster_version                          = "1.32"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  vpc_id                                   = dependency.vpc.outputs.vpc_id
  subnet_ids                              = dependency.vpc.outputs.public_subnets

  create_node_security_group = false
  cluster_security_group_additional_rules = {
    argocd_ingerss = {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all traffic from remote node/pod network"
      from_port   = 65535
      to_port     = 65535
      protocol    = "all"
      type        = "ingress"
    },
    eks_ingerss = {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all traffic from remote node/pod network"
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      type        = "ingress"
    },
    argocd_egerss = {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all traffic from remote node/pod network"
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      type        = "egress"
    }
  }


  eks_managed_node_group_defaults = {
    instance_types = ["t2.medium"]
  }

  eks_managed_node_groups = {
    nodes_group = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      #ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 10
      desired_size = 2
    }
  }

  tags = local.merged_tags
}