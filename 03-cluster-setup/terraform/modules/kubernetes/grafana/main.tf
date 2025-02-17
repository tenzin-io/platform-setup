terraform {
  required_version = "~> 1.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

locals {
  github_oauth_secret_name = "github-oauth-credentials"
}

resource "kubernetes_secret_v1" "github_oauth_secret" {
  count = var.enable_github_oauth ? 1 : 0
  metadata {
    name      = local.github_oauth_secret_name
    namespace = var.namespace
  }
  data = {
    GITHUB_OAUTH_CLIENT_ID     = var.github_oauth_client_id
    GITHUB_OAUTH_CLIENT_SECRET = var.github_oauth_client_secret
  }
}

resource "helm_release" "grafana" {
  depends_on       = [kubernetes_secret_v1.github_oauth_secret]
  name             = "grafana"
  chart            = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  version          = "8.6.1"
  namespace        = var.namespace
  create_namespace = true
  values = [
    templatefile("${path.module}/templates/values.yaml", {
      grafana_volume_size         = var.grafana_volume_size
      grafana_fqdn                = var.grafana_fqdn
      enable_github_oauth         = var.enable_github_oauth
      allowed_github_organization = var.allowed_github_organization
      github_oauth_secret_name    = local.github_oauth_secret_name
      prometheus_url              = var.prometheus_url
    })
  ]
}