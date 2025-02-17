variable "namespace" {
  type        = string
  default     = "cloudflare"
  description = "The namespace to deploy cert-manager"
}

variable "cloudflare_tunnel_token" {
  type        = string
  description = "CloudFlare tunnel token"
  sensitive   = true
}