variable "jupyterhub_fqdn" {
  default     = "jupyterhub.lan"
  type        = string
  description = "The fully qualified name of Jupyter Hub instance."
}

variable "enable_github_oauth" {
  type        = bool
  default     = false
  description = "Enable GitHub OAuth for Jupyter Hub."
}

variable "github_oauth_client_id" {
  type        = string
  default     = null
  description = "The GitHub OAuth client ID."
}

variable "github_oauth_client_secret" {
  type        = string
  default     = null
  sensitive   = true
  description = "The GitHub OAuth client secret."
}

variable "allowed_github_organizations" {
  type        = set(string)
  description = "The list of GitHub organizations that are allowed to access Jupyter Hub."
  default     = null
}

variable "jupyter_image_name" {
  type        = string
  description = "The Jupyter notebook image to use"
}

variable "jupyter_image_tag" {
  type        = string
  description = "The Jupyter notebook image tag to use"
}

variable "enable_nvidia_gpu" {
  type        = bool
  default     = false
  description = "The Jupyter notebook requests GPU resources"
}