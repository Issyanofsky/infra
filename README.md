# eks
instalation of the EKS cluster with 2 nodes and delpoying ARGO-CD.
the instalation is in folder infrastructure and should be installed in the order set by the number on the folders.
the folders are:

0-vpc - deploying a private VPC.
1-eks - deploying eks cluster with 2 nodes (t2.micro).
2-nlb:
    this terragrunt install nginx-ingress and deply the NLB loadbalancer.
    befor applying the nginx-ingress there it is nececery to download the help repo:

        helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
        helm repo update

3-argocd_install - deploy ARGO-CD on the EKS cluster and set the ingress (NGINX) configmap exposing to the internet.
