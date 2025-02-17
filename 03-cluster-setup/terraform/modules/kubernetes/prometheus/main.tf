terraform {
  required_version = "~> 1.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

#
# prometheus
#
resource "helm_release" "prometheus" {
  name             = "prometheus"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "66.2.2"
  namespace        = var.namespace
  create_namespace = true
  values = [
    templatefile("${path.module}/templates/values.yaml", {
      prometheus_volume_size     = var.prometheus_volume_size
      metrics_retention_duration = var.metrics_retention_duration
      metrics_scrape_interval    = var.metrics_scrape_interval
      kubernetes_cluster_name    = var.kubernetes_cluster_name
    })
  ]
}

#
# metrics server
#

resource "helm_release" "metrics_server" {
  depends_on = [helm_release.prometheus]
  name       = "metrics-server"
  chart      = "metrics-server"
  version    = "3.12.2"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  namespace  = var.namespace

  set {
    name  = "metrics.enabled"
    value = true
  }
  set {
    name  = "args"
    value = "{--kubelet-insecure-tls}"
  }
}