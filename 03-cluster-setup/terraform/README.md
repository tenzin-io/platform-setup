# README
This is a Terraform workspace to further setup the Kubernetes cluster.

## Local testing
- Link to the `tenzin-bot.key` to SSH into the hypervisor
- Create the `state.config`
- Initialize the backend state
- Setup the `terraform.tfvars`
- Setup the `kubernetes.conf` of the cluster
- Plan, apply, destroy

### Example state.config
```
key = "terraform/cluster-setup/testing.tfstate"
bucket = "tenzin-cloud"
region = "us-east-1"
```

### Example initialization
```
terraform init -backend-config=state.config
```

### Example terraform.tfvars
```hcl
cluster_name     = "t1"
cluster_uuid     = "cluster-uuid-here"
tailscale_network = "tail-network.ts.net"
```


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_cluster_uuid"></a> [cluster\_uuid](#input\_cluster\_uuid) | n/a | `string` | n/a | yes |
| <a name="input_tailscale_network"></a> [tailscale\_network](#input\_tailscale\_network) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->