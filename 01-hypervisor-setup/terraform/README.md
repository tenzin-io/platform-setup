# README

## Local testing
- Link to the `tenzin-bot.key` to SSH into the hypervisor
- Create the `state.config`
- Initialize the backend state
- Setup the `terraform.tfvars`
- Setup the AWS and Vault environment variables
- Plan, apply, destroy

### Example state.config
```
key = "terraform/cluster-provisioner/testing.tfstate"
bucket = "tenzin-cloud"
region = "us-east-1"
```

### Example initialization
```
terraform init -backend-config=state.config
```

### Example terraform.tfvars
```hcl
hypervisor_hostname = "vhost-1"

cluster_name     = "t1"
cluster_uuid     = "rand-value-here"
vpc_network_cidr = "10.100.0.0/16"

# for kubeconfig publishing
vault_address  = "https://vault.tenzin.io"
vault_username = "kubeconfig-publisher"
vault_password = "password-here"
```


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_cluster_uuid"></a> [cluster\_uuid](#input\_cluster\_uuid) | n/a | `string` | n/a | yes |
| <a name="input_hypervisor_hostname"></a> [hypervisor\_hostname](#input\_hypervisor\_hostname) | n/a | `string` | n/a | yes |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | n/a | `string` | n/a | yes |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | n/a | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | n/a | `string` | n/a | yes |
| <a name="input_vpc_network_cidr"></a> [vpc\_network\_cidr](#input\_vpc\_network\_cidr) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
