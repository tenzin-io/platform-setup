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

// host
module "hypervisor" {
  source          = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/hypervisor?ref=main"
  hypervisor_ip   = "192.168.200.251"
  vm_network_cidr = "10.255.1.0/24"
  vm_domain_name  = "vm.vhost-1"
}

// virtual machines on vhost_1
module "kube_nodes" {
  count           = 0
  source          = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/virtual-machine?ref=main"
  name            = "kube-${count.index}"
  datastore_name  = module.hypervisor.datastore_name
  network_id      = module.hypervisor.network_id
  base_volume_id  = module.hypervisor.base_volume_id
  cpu_count       = 7
  memory_size_mib = 110 * 1024  // gib
  disk_size_mib   = 1500 * 1024 // gib
  addresses       = ["10.255.1.1${count.index}"]
}