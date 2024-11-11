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
  uri = "qemu+ssh://tenzin-bot@vhost.lan/system?keyfile=tenzin-bot.key&sshauth=privkey&no_verify=1"
}

resource "libvirt_pool" "datastore" {
  name = "datastore"
  type = "dir"
  path = "/datastore"
}

resource "libvirt_volume" "ubuntu_base_volume" {
  #source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  source = "noble-server-cloudimg-amd64.qcow2"
  name   = "noble-server-cloudimg-amd64.qcow2"
  pool   = libvirt_pool.datastore.name
  format = "qcow2"
}

// virtual machines on vhost_1
module "cluster_1" {
  count          = 1
  source         = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/cluster?ref=main"
  cluster_name   = "t1"
  datastore_name = libvirt_pool.datastore.name
  base_volume_id = libvirt_volume.ubuntu_base_volume.id

  vpc_network_cidr = "10.255.1.0/24"

  vm_cpu_count       = 4
  vm_memory_size_mib = 16 * 1024 // gib
  vm_disk_size_mib   = 64 * 1024 // gib
  vm_data_disks = {
    "/dev/vdb" = {
      disk_size_mib = 128 * 1024 // gib
      fs_type       = "ext4"
      mount_path    = "/data"
    }
  }
}