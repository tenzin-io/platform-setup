provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "https://vault.tenzin.io"
}

provider "helm" {
  kubernetes {
    config_path = "kubernetes-admin.conf"
  }
}

provider "kubernetes" {
  config_path = "kubernetes-admin.conf"
}
