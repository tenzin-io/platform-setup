# README
A Terraform module repository to install Grafana on my Kubernetes clusters.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.grafana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret_v1.github_oauth_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_github_organization"></a> [allowed\_github\_organization](#input\_allowed\_github\_organization) | The GitHub organization name to allow access to Grafana. | `string` | `""` | no |
| <a name="input_cert_issuer_name"></a> [cert\_issuer\_name](#input\_cert\_issuer\_name) | The cert-manager certificate issuer name. | `string` | n/a | yes |
| <a name="input_enable_github_oauth"></a> [enable\_github\_oauth](#input\_enable\_github\_oauth) | Enable GitHub OAuth for Grafana. | `bool` | `false` | no |
| <a name="input_github_oauth_client_id"></a> [github\_oauth\_client\_id](#input\_github\_oauth\_client\_id) | GitHub OAuth app client id. | `string` | `""` | no |
| <a name="input_github_oauth_client_secret"></a> [github\_oauth\_client\_secret](#input\_github\_oauth\_client\_secret) | GitHub OAuth app client secret. | `string` | `""` | no |
| <a name="input_grafana_fqdn"></a> [grafana\_fqdn](#input\_grafana\_fqdn) | The Grafana hostname placed on ingress | `string` | n/a | yes |
| <a name="input_grafana_volume_size"></a> [grafana\_volume\_size](#input\_grafana\_volume\_size) | The persistent volume size to store Grafana data. | `string` | `"20Gi"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy Grafana. | `string` | `"monitoring"` | no |
<!-- END_TF_DOCS -->
