<div align="center">

# **Deploy ECS cluster with Fargate & EC2 Container Instances**

</div>

this is a deployment for a ECS cluster with EC2 containers and FARGATE.
the deployment is in order marked in the name of the files to impliment in the "right" order (from 0 to 7):

infrastructure ([infrastructure folder](infrastructure)):
    
- [0-vpc](infrastructure/0-vpc/) - create a VPC in AWS.
- [1-securitygroup](infrastructure/1-securitygroup/) - create a Security group for the VPC.
- [2-im_role](infrastructure/2-iam_role/) - create an IMRole for the EC2 instances.
- [3-ec2template](infrastructure/3-ec2template/) - create a launch template for the EC2 instances.
- [4-asg](infrastructure/4-asg) - create a Auto-Scaling-group for managing the EC2 instances.
- [5-nlb](infrastructure/5-nlb) - create a NLB load balancer.
- [6-ecs](infrastructure/6-ecs) - create the ECS cluster with EC2 instances and FARGATE.

running the nginx:

- [7-service_task](backend/service_task_nginx_ecs/) - create a service and task definition for deploying a nginx server and a cloudWatch container.

pictures after running the project:

**nginx deploymeny:**

![NGINX](/pictures/nginx_on_NLB.gif)

