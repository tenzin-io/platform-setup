variable "namespace" {
  default     = "monitoring"
  type        = string
  description = "The namespace to deploy Prometheus."
}

variable "metrics_retention_duration" {
  default     = "14d"
  type        = string
  description = "The duration to keep metrics."
}

variable "metrics_scrape_interval" {
  default     = "60s"
  type        = string
  description = "The frequency at which to collect metrics."
}

variable "prometheus_volume_size" {
  default     = "10Gi"
  type        = string
  description = "The volume size for Prometheus persistent volume."
}

variable "kubernetes_cluster_name" {
  default     = "kubernetes"
  type        = string
  description = "Add a label to the metrics identify the cluster name."
}