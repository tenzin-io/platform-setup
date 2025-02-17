variable "name" {
  type        = string
  description = "The name of the virtual machine"
}

variable "memory_size_mib" {
  type    = number
  default = 2048
}

variable "disk_size_mib" {
  type    = number
  default = 8192
}

variable "cpu_count" {
  type    = number
  default = 2
}

variable "launch_script" {
  type        = string
  default     = ""
  description = "The a custom script to run on the machine after cloud-init has finished"
}

variable "datastore_name" {
  type        = string
  description = "The name of the datastore"
}

variable "base_volume" {
  type = object({
    id   = string
    name = string
    pool = string
  })
  description = "The base volume to use for the OS root disk"
}

variable "automation_user" {
  type = string
}

variable "automation_user_pubkey" {
  type = string
}

variable "has_gpu_passthru" {
  type    = bool
  default = false
}

variable "gpu_pci_bus" {
  type    = string
  default = ""
}

variable "ip_address" {
  type = string
}

variable "gateway_address" {
  type = string
}
