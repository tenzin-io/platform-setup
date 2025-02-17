data "vault_generic_secret" "cloudflare_tunnel" {
  path = "secrets/cloudflare/tunnels/kubernetes-1"
}

data "vault_generic_secret" "grafana" {
  path = "secrets/grafana"
}

data "vault_generic_secret" "jupyterhub" {
  path = "secrets/jupyterhub"
}
