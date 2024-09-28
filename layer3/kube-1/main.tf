terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
  backend "local" {
    path = "local.tfstate"
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@vhost-2.lan/system?sshauth=privkey&no_verify=1"
}

data "libvirt_node_info" "node" {}


resource "libvirt_network" "ubuntu_network" {
  name      = "vm-network"
  mode      = "route"
  bridge    = "virbr1"
  autostart = true
  domain    = "virtual.lan"
  addresses = ["10.255.2.0/24"]
  dhcp {
    enabled = true
  }

  dns {
    enabled    = true
    local_only = false
  }
}

resource "libvirt_pool" "ubuntu_pool" {
  name = "ubuntu"
  type = "dir"
  path = "/var/lib/libvirt/images"
}
resource "libvirt_volume" "ubuntu_disk" {
  source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  name   = "ubuntu-noble-server"
  pool   = libvirt_pool.ubuntu_pool.name
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "ubuntu_cloudinit_seed" {
  name = "ubuntu-cloudinit-seed"
  user_data = templatefile("${path.module}/templates/cloud_init.cfg", {
    hostname    = "kube-1"
    domain_name = "virtual.lan"
  })
  pool = libvirt_pool.ubuntu_pool.name
}

resource "libvirt_domain" "vm" {
  name   = "kube-1"
  memory = "20480"
  cpu {
    mode = "host-passthrough"
  }
  machine = "q35"
  vcpu    = 7

  firmware = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  nvram {
    file = "/var/lib/libvirt/qemu/nvram/ubuntu_VARS.fd"
  }

  xml{
    xslt = file("cdrom-model.xsl")
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  network_interface {
    network_id     = libvirt_network.ubuntu_network.id
    hostname       = "kube-1"
    wait_for_lease = true
    addresses      = ["10.255.2.10"]
  }

  cloudinit = libvirt_cloudinit_disk.ubuntu_cloudinit_seed.id
  disk {
    volume_id = libvirt_volume.ubuntu_disk.id
  }
}