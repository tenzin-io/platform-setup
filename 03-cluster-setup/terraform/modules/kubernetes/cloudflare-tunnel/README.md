# README
A Terraform module that will install cloudflare-tunnel for my home lab Kubernetes cluster.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_tunnel_token"></a> [cloudflare\_tunnel\_token](#input\_cloudflare\_tunnel\_token) | CloudFlare tunnel token | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy cert-manager | `string` | `"cloudflare"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
