# README
A Terraform module to deploy Jupyter Hub to my home lab Kubernetes cluster

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_github_organizations"></a> [allowed\_github\_organizations](#input\_allowed\_github\_organizations) | The list of GitHub organizations that are allowed to access Jupyter Hub. | `set(string)` | `null` | no |
| <a name="input_cert_issuer_name"></a> [cert\_issuer\_name](#input\_cert\_issuer\_name) | The name of the cert-manager certificate issuer | `string` | n/a | yes |
| <a name="input_enable_github_oauth"></a> [enable\_github\_oauth](#input\_enable\_github\_oauth) | Enable GitHub OAuth for Jupyter Hub. | `bool` | `false` | no |
| <a name="input_enable_ingress"></a> [enable\_ingress](#input\_enable\_ingress) | Create JupyterHub ingress | `bool` | `false` | no |
| <a name="input_enable_nvidia_gpu"></a> [enable\_nvidia\_gpu](#input\_enable\_nvidia\_gpu) | The Jupyter notebook requests GPU resources | `bool` | `false` | no |
| <a name="input_github_oauth_client_id"></a> [github\_oauth\_client\_id](#input\_github\_oauth\_client\_id) | The GitHub OAuth client ID. | `string` | `null` | no |
| <a name="input_github_oauth_client_secret"></a> [github\_oauth\_client\_secret](#input\_github\_oauth\_client\_secret) | The GitHub OAuth client secret. | `string` | `null` | no |
| <a name="input_jupyter_image_name"></a> [jupyter\_image\_name](#input\_jupyter\_image\_name) | The Jupyter notebook image to use | `string` | `"quay.io/jupyterhub/k8s-singleuser-sample"` | no |
| <a name="input_jupyter_image_tag"></a> [jupyter\_image\_tag](#input\_jupyter\_image\_tag) | The Jupyter notebook image tag to use | `string` | `"3.3.7"` | no |
| <a name="input_jupyterhub_fqdn"></a> [jupyterhub\_fqdn](#input\_jupyterhub\_fqdn) | The fully qualified name of Jupyter Hub instance. | `string` | `"jupyterhub.lan"` | no |
<!-- END_TF_DOCS -->