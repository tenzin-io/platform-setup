terraform {
  required_version = "~> 1.9"
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
    #    aws = {
    #      source  = "hashicorp/aws"
    #      version = "~> 5.0"
    #    }
    #    cloudflare = {
    #      source  = "cloudflare/cloudflare"
    #      version = "~> 4.0"
    #    }
  }

  backend "local" {}
}

module "cloudflare_tunnel" {
  source                  = "./modules/kubernetes/cloudflare-tunnel"
  cloudflare_tunnel_token = data.vault_generic_secret.cloudflare_tunnel.data["tunnel_token"]
}

module "prometheus" {
  source = "./modules/kubernetes/prometheus"
}

# module "actions_runner" {
#   source     = "git::https://github.com/tenzin-io/modules.git//kubernetes/actions-runner?ref=main"
#   depends_on = [module.calico]
# }
# 
# module "actions_runner_org" {
#   depends_on                 = [module.actions_runner]
#   runner_set_name            = "k8s-1-runners"
#   source                     = "git::https://github.com/tenzin-io/modules.git//kubernetes/actions-runner-set?ref=main"
#   runner_image               = "ghcr.io/tenzin-io/actions-runner:0.0.3"
#   github_config_urls         = ["https://github.com/tenzin-io"]
#   github_app_id              = data.vault_generic_secret.github_tenzin_org.data["github_app_id"]
#   github_app_installation_id = data.vault_generic_secret.github_tenzin_org.data["github_app_installation_id"]
#   github_app_private_key     = data.vault_generic_secret.github_tenzin_org.data["github_app_private_key"]
# }

module "jupyterhub" {
  source                       = "./modules/kubernetes/jupyterhub"
  enable_github_oauth          = true
  github_oauth_client_id       = data.vault_generic_secret.jupyterhub.data["github_oauth_client_id"]
  github_oauth_client_secret   = data.vault_generic_secret.jupyterhub.data["github_oauth_client_secret"]
  allowed_github_organizations = ["tenzin-io"]
  jupyter_image_name           = "quay.io/jupyter/pytorch-notebook"
  jupyter_image_tag            = "x86_64-cuda12-hub-5.2.1"
  jupyterhub_fqdn              = "jupyterhub.tenzin.io"
  enable_nvidia_gpu            = true
}

module "grafana" {
  source                      = "./modules/kubernetes/grafana"
  enable_github_oauth         = true
  github_oauth_client_id      = data.vault_generic_secret.grafana.data["github_oauth_client_id"]
  github_oauth_client_secret  = data.vault_generic_secret.grafana.data["github_oauth_client_secret"]
  allowed_github_organization = "tenzin-io"
  grafana_fqdn                = "grafana.tenzin.io"
  prometheus_url              = module.prometheus.prometheus_url
}

module "nvidia_gpu_operator" {
  count      = 1
  source     = "./modules/kubernetes/nvidia-gpu-operator"
  gpu_slices = 10
}

# 
# module "actions_runner_user" {
#   depends_on      = [module.actions_runner]
#   runner_set_name = "tlhakhan"
#   source          = "git::https://github.com/tenzin-io/modules.git//kubernetes/actions-runner-set?ref=main"
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

