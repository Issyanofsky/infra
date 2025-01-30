# infra


2-nlb:
this terragrunt install nginx-ingress and deply the NLB loadbalancer.
befor applying the nginx-ingress there it is nececery to download the help repo:

    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update

