output "prometheus_url" {
  value = "http://prometheus-kube-prometheus-prometheus.${var.namespace}.svc.cluster.local:9090"
}

output "alertmanager_url" {
  value = "http://alertmanager-operated.${var.namespace}.svc.cluster.local:9093"
}