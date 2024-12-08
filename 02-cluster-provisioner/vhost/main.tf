terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/02-vm-provisioner/vhost.tfstate"
    dynamodb_table = "tenzin-io"
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "hypervisor" {
  backend = "s3"
  config = {
    bucket = "tenzin-io"
    key    = "terraform/01-hypervisor-setup/vhost.tfstate"
    region = "us-east-1"
  }
}

locals {
  hypervisor_hostname     = data.terraform_remote_state.hypervisor.outputs.hypervisor_connection.hostname
  hypervisor_ssh_user     = data.terraform_remote_state.hypervisor.outputs.hypervisor_connection.ssh_user
  hypervisor_ssh_key_name = data.terraform_remote_state.hypervisor.outputs.hypervisor_connection.ssh_key_name
}

provider "libvirt" {
  uri = "qemu+ssh://${local.hypervisor_ssh_user}@${local.hypervisor_hostname}/system?keyfile=${local.hypervisor_ssh_key_name}&sshauth=privkey&no_verify=1"
}

provider "vault" {
  address = "https://vault.tenzin.io"
}

data "vault_generic_secret" "dockerhub" {
  path = "secrets/dockerhub"
}

data "vault_generic_secret" "tailscale" {
  path = "secrets/tailscale"
}

resource "null_resource" "install_packages" {
  provisioner "local-exec" {
    command = <<-EOT
      sudo apt-get update
      sudo apt-get install -y mkisofs xsltproc
    EOT
  }
}

resource "random_uuid" "cluster_uuid" {}

// virtual machines on vhost_1
module "cluster_1" {
  depends_on = [null_resource.install_packages]
  count      = 1
  source         = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/cluster?ref=main"

  cluster_name = var.cluster_name
  cluster_uuid = random_uuid.cluster_uuid.result

  vpc_network_mode = "nat"
  vpc_network_cidr = var.vpc_network_cidr

  base_volume = {
    id   = data.terraform_remote_state.hypervisor.outputs.base_cloud_image.id
    name = data.terraform_remote_state.hypervisor.outputs.base_cloud_image.name
    pool = data.terraform_remote_state.hypervisor.outputs.base_cloud_image.pool_name
  }

  # for container image pull
  docker_hub_user  = data.vault_generic_secret.dockerhub.data["username"]
  docker_hub_token = data.vault_generic_secret.dockerhub.data["api_token"]

  create_agent_node  = true
  tailscale_auth_key = data.vault_generic_secret.tailscale.data["auth_key"]

  worker_node_count      = 3
  worker_cpu_count       = 4
  worker_memory_size_mib = 16 * 1024 // gib
  worker_disk_size_mib   = 64 * 1024 // gib
}

# module "simple_network" {
#   source       = "../terraform-modules/libvirt/virtual-network"
#   name         = "simple-network"
#   network_cidr = "10.0.0.0/16"
# }
# 
# resource "libvirt_pool" "simple_datastore" {
#   name = "simple-datastore"
#   type = "dir"
#   target {
#     path = "/data/simple-datastore"
#   }
# }
# 
# module "simple_vm" {
#   source         = "../terraform-modules/libvirt/virtual-machine"
#   name           = "simple-vm-0"
#   datastore_name = libvirt_pool.simple_datastore.name
#   base_volume = {
#     id   = libvirt_volume.ubuntu_cloud_image.id
#     name = libvirt_volume.ubuntu_cloud_image.name
#     pool = libvirt_pool.cloud_images.name
#   }
#   network_id      = module.simple_network.network_id
#   addresses       = [cidrhost(module.simple_network.network_cidr, 4)]
#   cpu_count       = 4
#   memory_size_mib = 8 * 1024  // gib
#   disk_size_mib   = 30 * 1024 // gib
# 
#   launch_script = templatefile("${path.module}/templates/simple_vm.sh", {
#     tailscale_auth_key = "tskey-auth-kbxjqQTxAV11CNTRL-1jTgaxosyS9iktZ6YtqPT9TR4ADDi2UTY"
#   })
# }