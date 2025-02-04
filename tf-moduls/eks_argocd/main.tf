module "argocd" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-argocd.git?ref=0.3.5"

  enabled = true

  helm_services = [
    {
      name          = "argo-cd"
      release_name  = "argo-cd"
      chart_version = var.chart_version
      settings = {
        "server" = {
          "service" = {
            "type" = "ClusterIP"
            "port" = 80
          }
          "extraArgs" = ["--insecure"] 
          "ingress" = {
            "enabled" = true
            "https"   = false
            "paths"   = ["/"]
            "annotations" = {
              "ingress.kubernetes.io/group.name"             = "dev-apps-private"
              "kubernetes.io/ingress.class"                  = "nginx"
              "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
              "nginx.ingress.kubernetes.io/rewrite-target"   = "/"
              "nginx.ingress.kubernetes.io/ssl-redirect"     = "false"
            }
            "hosts" = var.hosts
          }
        }
      }
    }  
  ]
}

