<div align="center">

# **DEVOPS EXAM**

</div>


This repo is a devops exam practice.
in this task we deploy a terragrunt structure folders for deploying two projects:
    - [deploy ECS cluster](products/project_ECS/us-east-1/my/README.md) - Deploy ECS cluster with Fargate & EC2 Container Instances. it set under folder project_ECS.
    - [deply EKS cluster](products/project_EKS/us-east-1/my/README.md) - Deploy EKS cluster with managed nodegorups. it set under the folder project_EKS.
    - [modules created](tf-moduls) - here are all the modules needed for the deployment.

the terragrunt use S3 bucket (and dynodb) to keep the tfstate files.

