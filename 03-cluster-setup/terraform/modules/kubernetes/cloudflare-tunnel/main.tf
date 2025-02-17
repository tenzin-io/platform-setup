terraform {
  required_version = "~> 1.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}
resource "helm_release" "cloudflare_tunnel" {
  name             = "cloudflare-tunnel"
  namespace        = var.namespace
  create_namespace = true
  repository       = "oci://ghcr.io/tenzin-io"
  chart            = "cloudflare-tunnel"
  version          = "v0.0.0"
  wait             = true

  set_sensitive {
    name  = "secret.tunnelToken"
    value = var.cloudflare_tunnel_token
  }
}