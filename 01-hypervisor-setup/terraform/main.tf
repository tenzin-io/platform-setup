terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/01-hypervisor-setup/vhost.tfstate"
    dynamodb_table = "tenzin-io"
    region         = "us-east-1"
  }
}

locals {
  hypervisor_hostname     = "vhost.tail508ed.ts.net"
  hypervisor_ssh_user     = "tenzin-bot"
  hypervisor_ssh_key_name = "tenzin-bot.key"
}

provider "libvirt" {
  uri = "qemu+ssh://${local.hypervisor_ssh_user}@${local.hypervisor_hostname}/system?keyfile=${local.hypervisor_ssh_key_name}&sshauth=privkey&no_verify=1"
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