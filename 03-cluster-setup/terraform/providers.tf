provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubernetes.conf"
  }
}

provider "kubernetes" {
  config_path = "${path.module}/kubernetes.conf"
}

provider "vault" {
  address = var.vault_address
  auth_login_userpass {
    username = var.vault_username
    password = var.vault_password
  }
}
