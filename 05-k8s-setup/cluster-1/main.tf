terraform {
  required_version = "~> 1.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/cluster-1.state"
    dynamodb_table = "tenzin-io"
    region         = "us-east-1"
  }
}

module "calico" {
  source           = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/calico?ref=main"
  pod_cidr_network = "10.253.0.0/16"
}

module "local_path_provisioner" {
  source     = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/local-path-provisioner?ref=main"
  local_path = "/data"
  depends_on = [module.calico]
}

module "metallb" {
  source        = "git::https://github.com/tenzin-io/terraform-tenzin-homelab.git//kubernetes/metallb?ref=main"
  ip_pool_range = "10.255.1.200/32"
  depends_on    = [module.calico]
}

module "cert_manager" {
  source                     = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/cert-manager?ref=main"
  cloudflare_api_token       = data.vault_generic_secret.cloudflare_automation.data["api_token"]
  enable_lets_encrypt_issuer = true
  depends_on                 = [module.calico]
}

module "nginx_ingress" {
  source                   = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/ingress-nginx?ref=main"
  enable_cloudflare_tunnel = true
  cloudflare_tunnel_token  = data.vault_generic_secret.cloudflare_tunnel.data["tunnel_token"]
  depends_on               = [module.cert_manager]
}

# module "prometheus" {
#   depends_on          = [module.cert_manager, module.local_path_provisioner]
#   enable_ingress      = true
#   enable_basic_auth   = true
#   basic_auth_password = data.vault_generic_secret.basic_auth.data["htpasswd"]
#   prometheus_fqdn     = "prometheus.vm.vhost-1"
#   source              = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/prometheus?ref=main"
# }

# module "actions_runner" {
#   source     = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/actions-runner?ref=main"
#   depends_on = [module.calico]
# }
# 
# module "actions_runner_org" {
#   depends_on                 = [module.actions_runner]
#   runner_set_name            = "k8s-1-runners"
#   source                     = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/actions-runner-set?ref=main"
#   runner_image               = "ghcr.io/tenzin-io/actions-runner:0.0.3"
#   github_config_urls         = ["https://github.com/tenzin-io"]
#   github_app_id              = data.vault_generic_secret.github_tenzin_org.data["github_app_id"]
#   github_app_installation_id = data.vault_generic_secret.github_tenzin_org.data["github_app_installation_id"]
#   github_app_private_key     = data.vault_generic_secret.github_tenzin_org.data["github_app_private_key"]
# }
# 
# module "jupyterhub" {
#   depends_on                   = [module.local_path_provisioner]
#   source                       = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/jupyterhub?ref=main"
#   enable_github_oauth          = true
#   github_oauth_client_id       = data.vault_generic_secret.jupyterhub.data["github_oauth_client_id"]
#   github_oauth_client_secret   = data.vault_generic_secret.jupyterhub.data["github_oauth_client_secret"]
#   allowed_github_organizations = ["tenzin-io"]
#   jupyter_image_name           = "quay.io/jupyter/pytorch-notebook"
#   jupyter_image_tag            = "pytorch-2.4.1"
#   jupyterhub_fqdn              = "jupyterhub.tenzin.io"
# }
# 
# module "grafana" {
#   depends_on                  = [module.cert_manager, module.local_path_provisioner, module.prometheus]
#   source                      = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/grafana?ref=main"
#   enable_github_oauth         = true
#   github_oauth_client_id      = data.vault_generic_secret.grafana.data["github_oauth_client_id"]
#   github_oauth_client_secret  = data.vault_generic_secret.grafana.data["github_oauth_client_secret"]
#   allowed_github_organization = "tenzin-io"
#   grafana_fqdn                = "grafana.tenzin.io"
# }


# module "nvidia_gpu_operator" {
#   source     = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/nvidia-gpu-operator?ref=main"
#   gpu_slices = 10
#   depends_on = [module.calico]
# }

# 
# module "actions_runner_user" {
#   depends_on      = [module.actions_runner]
#   runner_set_name = "tlhakhan"
#   source          = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/actions-runner-set?ref=main"
#   runner_image    = "ghcr.io/tenzin-io/actions-runner:0.0.2"
#   github_config_urls = [
#     "https://github.com/tlhakhan/learn-wasm",
#     "https://github.com/tlhakhan/learn-rust"
#   ]
#   github_app_id              = data.vault_generic_secret.github_tlhakhan_user.data["github_app_id"]
#   github_app_installation_id = data.vault_generic_secret.github_tlhakhan_user.data["github_app_installation_id"]
#   github_app_private_key     = data.vault_generic_secret.github_tlhakhan_user.data["github_app_private_key"]
# }
# 

