output "grafana_url" {
  value = "http://grafana.${var.namespace}.svc.cluster.local:80"
}