

here is a description of the modules:

modules for ECS project:

- **VPC** - local module that create the VPC.
- **asg** -  local module that create the Autoscaling group for the ECS nodes.
-  **security_group** -  local module for creating security_group.
-  **nlb** - local module for creating a NLB Load-balancer.
-  **iam_role** - local module for creating a IAM role.
-  **ec2_template** - local module for creating a Launch Template for the nodes.
-  **ecs_cluster** - loacl module for creating the ECS cluster.

- **nginx_service_task** -this module create the backend. it install nginx and sidecar.

modules for the EKS project:

- **eks_nginx_controller** - module that used helm to install ingress (nginx) and create a gecurity group for it.
- **eks_argocd** - module use a helm chart for installing Argo-cd and set the ingress role.
