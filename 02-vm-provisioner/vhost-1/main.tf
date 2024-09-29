terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/vhost-1.state"
    dynamodb_table = "tenzin-io"
    region         = "us-east-1"
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@vhost-1.lan/system?keyfile=ansible.key&sshauth=privkey&no_verify=1"
}

// base disk
resource "libvirt_volume" "ubuntu_cloudimg" {
  source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  name   = "ubuntu-noble-server-cloudimg-amd64.qcow2"
  pool   = libvirt_pool.datastore.name
  format = "qcow2"
}

// virtual machines
module "kube_1" {
  count           = 0
  source          = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/virtual-machine?ref=main"
  name            = "kube-1"
  datastore_name  = libvirt_pool.datastore.name
  network_id      = libvirt_network.network.id
  base_volume_id  = libvirt_volume.ubuntu_cloudimg.id
  cpu_count       = 4
  memory_size_mib = 12 * 1024  // gib
  disk_size_mib   = 200 * 1024 // gib
  addresses       = ["10.255.1.11"]
}