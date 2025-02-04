<div align="center">

# **Deploy EKS cluster with managed nodegorups**

![Rick Sanchez](pictures/eks_argocd_web.gif)

</div>


# task C 

instalation of the EKS cluster with 2 nodes and delpoying ARGO-CD. the setting is set to work on HTTP.
the instalation is in folder infrastructure and should be installed in the order set by the number on the folders.
the folders are:

**0-vpc** - deploying a private VPC. using a module from terraform repository that create a VPC (https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest).

**1-eks** - deploying eks cluster with 2 nodes (t2.medium - argocd need more resources then t2.micro). the deployment of the EKS  was done using a module from terraform repository
(https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest).

**2-nlb:**
    this terragrunt install nginx-ingress and deply the NLB loadbalancer. it based on a module i created for installing the ingress (nginx) on the EKS cluster 
    (tf-modules\eks_nginx_controller)
    befor applying the nginx-ingress there it is nececery to download the help repo:

        helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
        helm repo update

**3-argocd_install** - deploy ARGO-CD on the EKS cluster and set the ingress (NGINX) configmap exposing to the internet. the deployment use a module from the 
terraform repository (https://registry.terraform.io/modules/squareops/argocd/kubernetes/latest).

