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
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    key            = ""
    bucket         = ""
    dynamodb_table = ""
    region         = ""
  }
}


data "vault_generic_secret" "kubeconfig" {
  path = "kubernetes-secrets/kubeconfig/${var.cluster_name}-${var.cluster_uuid}"
}


resource "terraform_data" "kubeconfig" {
  triggers_replace = [fileexists("${path.module}/kubernetes-admin.conf")]
}


resource "local_sensitive_file" "kubeconfig" {
  content         = data.vault_generic_secret.kubeconfig.data["kubeconfig"]
  filename        = "${path.module}/kubernetes-admin.conf"
  file_permission = "0600"
  lifecycle {
    replace_triggered_by = [terraform_data.kubeconfig]
  }
}

# module "cloudflare_tunnel" {
#   source                  = "./terraform-modules/kubernetes/cloudflare-tunnel"
#   cloudflare_tunnel_token = data.vault_generic_secret.cloudflare_tunnel.data["tunnel_token"]
# }

module "prometheus" {
  source = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/prometheus?ref=main"
  # source = "./terraform-modules/kubernetes/prometheus"
}
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
#   source                       = "./terraform-modules/kubernetes/jupyterhub"
#   enable_github_oauth          = true
#   github_oauth_client_id       = data.vault_generic_secret.jupyterhub.data["github_oauth_client_id"]
#   github_oauth_client_secret   = data.vault_generic_secret.jupyterhub.data["github_oauth_client_secret"]
#   allowed_github_organizations = ["tenzin-io"]
#   jupyter_image_name           = "quay.io/jupyter/pytorch-notebook"
#   jupyter_image_tag            = "hub-5.2.1"
#   jupyterhub_fqdn              = "jupyterhub.tenzin.io"
# }
# 
# 
# module "grafana" {
#   source                      = "./terraform-modules/kubernetes/grafana"
#   enable_github_oauth         = true
#   github_oauth_client_id      = data.vault_generic_secret.grafana.data["github_oauth_client_id"]
#   github_oauth_client_secret  = data.vault_generic_secret.grafana.data["github_oauth_client_secret"]
#   allowed_github_organization = "tenzin-io"
#   grafana_fqdn                = "grafana.tenzin.io"
#   prometheus_url              = module.prometheus.prometheus_url
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

