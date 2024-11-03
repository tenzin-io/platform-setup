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
  uri = "qemu+ssh://tenzin-bot@vhost-1.lan/system?keyfile=tenzin-bot.key&sshauth=privkey&no_verify=1"
}

// host
module "hypervisor" {
  source          = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/hypervisor?ref=main"
  hypervisor_ip   = "192.168.200.251"
  vm_network_cidr = "10.255.1.0/24"
  vm_domain_name  = "vm.vhost-1"

  dns_host_records = [{
    hostname    = "cluster-1",
    host_number = 150
    }, {
    hostname    = "metallb-1",
    host_number = 200
  }]
}

// virtual machines on vhost_1
module "cluster_1" {
  count           = 1
  source          = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/virtual-machine?ref=main"
  name            = "kube-${count.index}"
  datastore_name  = module.hypervisor.datastore_name
  network_id      = module.hypervisor.network_id
  base_volume_id  = module.hypervisor.base_volume_id
  cpu_count       = 6
  memory_size_mib = 48 * 1024  // gib
  disk_size_mib   = 128 * 1024 // gib
  addresses       = [cidrhost(module.hypervisor.vm_network_cidr, 10 + count.index)]
  data_disks = {
    "disk-1" = {
      disk_size_mib = 350 * 1024 // gib
    }
  }
}

module "storage_node" {
  count           = 0
  source          = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/virtual-machine?ref=main"
  name            = "stor-${count.index}"
  datastore_name  = module.hypervisor.datastore_name
  network_id      = module.hypervisor.network_id
  base_volume_id  = module.hypervisor.base_volume_id
  cpu_count       = 4
  memory_size_mib = 16 * 1024  // gib
  disk_size_mib   = 128 * 1024 // gib
  addresses       = [cidrhost(module.hypervisor.vm_network_cidr, 90 + count.index)]
  data_disks = {
    "disk-1" = {
      disk_size_mib = 250 * 1024 // gib
    }
  }
}