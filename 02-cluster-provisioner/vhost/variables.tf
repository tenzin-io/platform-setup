variable "cluster_name" {
  type = string
}

variable "cluster_uuid" {
  type = string
}

variable "vpc_network_cidr" {
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