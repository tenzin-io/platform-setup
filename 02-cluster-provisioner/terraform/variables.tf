variable "hypervisor_hostname" {
  type = string
}

variable "hypervisor_automation_user" {
  type = string
}

variable "hypervisor_keyfile" {
  type = string
}

variable "vault_address" {
  type = string
}

variable "vault_username" {
  type = string
}

variable "vault_password" {
  type      = string
  sensitive = true
}

variable "vm_automation_user" {
  type = string
}

variable "vm_automation_user_pubkey" {
  type = string
}
