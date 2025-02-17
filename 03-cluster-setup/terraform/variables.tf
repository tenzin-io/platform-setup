variable "vault_address" { type = string }
variable "vault_username" { type = string }
variable "vault_password" {
  type      = string
  sensitive = true
}
