terraform {
  required_version = "~> 1.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

resource "helm_release" "jupyterhub" {
  name             = "jupyterhub"
  chart            = "jupyterhub"
  repository       = "https://hub.jupyter.org/helm-chart/"
  version          = "4.0.0"
  namespace        = "jupyterhub"
  create_namespace = true
  timeout          = 30 * 60 // minutes
  values = [
    templatefile("${path.module}/templates/values.yaml", {
      jupyterhub_fqdn              = var.jupyterhub_fqdn,
      enable_github_oauth          = var.enable_github_oauth,
      github_oauth_client_id       = var.github_oauth_client_id,
      github_oauth_client_secret   = var.github_oauth_client_secret,
      allowed_github_organizations = var.allowed_github_organizations,
      gpu_count                    = var.enable_nvidia_gpu ? 1 : 0,
    })
  ]

  set {
    name  = "singleuser.image.name"
    value = var.jupyter_image_name
  }

  set {
    name  = "singleuser.image.tag"
    value = var.jupyter_image_tag
  }

}
