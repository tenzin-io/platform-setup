variable "gpu_slices" {
  type        = number
  default     = 8
  description = "The number of GPU slices"
}

variable "namespace" {
  type        = string
  default     = "gpu-operator"
  description = "The namespace to install the nvidia-gpu-operator chart"
}