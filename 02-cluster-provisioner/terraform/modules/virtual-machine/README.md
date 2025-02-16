# README
A Terraform module that creates virtual machines on a libvirtd host.
<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automation_user"></a> [automation\_user](#input\_automation\_user) | n/a | `string` | n/a | yes |
| <a name="input_automation_user_pubkey"></a> [automation\_user\_pubkey](#input\_automation\_user\_pubkey) | n/a | `string` | n/a | yes |
| <a name="input_base_volume"></a> [base\_volume](#input\_base\_volume) | The base volume to use for the OS root disk | <pre>object({<br/>    id   = string<br/>    name = string<br/>    pool = string<br/>  })</pre> | n/a | yes |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | n/a | `number` | `2` | no |
| <a name="input_datastore_name"></a> [datastore\_name](#input\_datastore\_name) | The name of the datastore | `string` | n/a | yes |
| <a name="input_disk_size_mib"></a> [disk\_size\_mib](#input\_disk\_size\_mib) | n/a | `number` | `8192` | no |
| <a name="input_launch_script"></a> [launch\_script](#input\_launch\_script) | The a custom script to run on the machine after cloud-init has finished | `string` | `""` | no |
| <a name="input_memory_size_mib"></a> [memory\_size\_mib](#input\_memory\_size\_mib) | n/a | `number` | `2048` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the virtual machine | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | The name of the host |
<!-- END_TF_DOCS -->