provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "https://vault.tenzin.io"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubernetes.conf"
    proxy_url   = "http://${var.cluster_name}-${var.cluster_uuid}-agent-node-0.${var.tailscale_network}:3128"
  }
}

provider "kubernetes" {
  config_path = "${path.module}/kubernetes.conf"
  proxy_url   = "http://${var.cluster_name}-${var.cluster_uuid}-agent-node-0.${var.tailscale_network}:3128"
}
