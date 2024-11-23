terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/vhost-1.state"
    dynamodb_table = "tenzin-io"
    region         = "us-east-1"
  }
}

provider "vault" {
  address = "https://vault.tenzin.io"
}

provider "libvirt" {
  uri = "qemu+ssh://tenzin-bot@vhost.tail508ed.ts.net/system?keyfile=tenzin-bot.key&sshauth=privkey&no_verify=1"
}

data "vault_generic_secret" "dockerhub" {
  path = "secrets/dockerhub"
}

resource "libvirt_pool" "cloud_images" {
  name = "cloud-images"
  type = "dir"
  target {
    path = "/data/cloud-images"
  }
}

resource "libvirt_volume" "ubuntu_cloud_image" {
  source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  name   = "noble-server-cloudimg-amd64.img"
  pool   = libvirt_pool.cloud_images.name
  format = "qcow2"
}

// virtual machines on vhost_1
module "cluster_1" {
  count = 0
  # source         = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/cluster?ref=main"
  source = "../terraform-modules/libvirt/cluster"

  hypervisor_connection = {
    host        = "vhost.tail508ed.ts.net"
    user        = "tenzin-bot"
    private_key = file("${path.module}/tenzin-bot.key")
  }

  cluster_name   = "tenzin"
  cluster_number = 1

  vpc_network_cidr         = "10.255.1.0/24"
  vpc_domain_name          = "virtual.lan"
  alternative_domain_names = ["tenzin.io", "tenzin.cloud"]

  base_volume = {
    id   = libvirt_volume.ubuntu_cloud_image.id
    name = libvirt_volume.ubuntu_cloud_image.name
    pool = libvirt_pool.cloud_images.name
  }

  # for container image pull
  docker_hub_user  = data.vault_generic_secret.dockerhub.data["username"]
  docker_hub_token = data.vault_generic_secret.dockerhub.data["api_token"]

  vm_node_count      = 3
  vm_cpu_count       = 4
  vm_memory_size_mib = 16 * 1024 // gib
  vm_disk_size_mib   = 64 * 1024 // gib
}