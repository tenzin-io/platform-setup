# README
A Terraform module repository to install Prometheus on my home lab Kubernetes clusters.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_receiver_name"></a> [alert\_receiver\_name](#input\_alert\_receiver\_name) | Name of the alertmanager receiver | `string` | `""` | no |
| <a name="input_alert_receiver_password"></a> [alert\_receiver\_password](#input\_alert\_receiver\_password) | Password to use with the alert receiver API | `string` | `""` | no |
| <a name="input_alert_receiver_url"></a> [alert\_receiver\_url](#input\_alert\_receiver\_url) | API endpoint to send webhook alert requests | `string` | `""` | no |
| <a name="input_alert_receiver_username"></a> [alert\_receiver\_username](#input\_alert\_receiver\_username) | Username to use with the alert receiver API | `string` | `""` | no |
| <a name="input_basic_auth_password"></a> [basic\_auth\_password](#input\_basic\_auth\_password) | The basic auth credentials. | `string` | `null` | no |
| <a name="input_enable_alertmanager"></a> [enable\_alertmanager](#input\_enable\_alertmanager) | Enable Alertmanager | `bool` | `false` | no |
| <a name="input_enable_basic_auth"></a> [enable\_basic\_auth](#input\_enable\_basic\_auth) | Protect ingress using basic auth. | `bool` | `false` | no |
| <a name="input_enable_ingress"></a> [enable\_ingress](#input\_enable\_ingress) | Create a Prometheus ingress. | `bool` | `false` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Add a label to the metrics identify the cluster name. | `string` | `"kubernetes"` | no |
| <a name="input_metrics_retention_duration"></a> [metrics\_retention\_duration](#input\_metrics\_retention\_duration) | The duration to keep metrics. | `string` | `"14d"` | no |
| <a name="input_metrics_scrape_interval"></a> [metrics\_scrape\_interval](#input\_metrics\_scrape\_interval) | The frequency at which to collect metrics. | `string` | `"60s"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy Prometheus. | `string` | `"monitoring"` | no |
| <a name="input_prometheus_fqdn"></a> [prometheus\_fqdn](#input\_prometheus\_fqdn) | The Prometheus DNS name to place on ingress. | `string` | `"prometheus.lan"` | no |
| <a name="input_prometheus_volume_size"></a> [prometheus\_volume\_size](#input\_prometheus\_volume\_size) | The volume size for Prometheus persistent volume. | `string` | `"10Gi"` | no |
<!-- END_TF_DOCS -->