terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/vhost-2.state"
    dynamodb_table = "tenzin-io"
    region         = "us-east-1"
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@vhost-2.lan/system?keyfile=ansible.key&sshauth=privkey&no_verify=1"
}

// host
module "hypervisor" {
  source          = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/hypervisor?ref=main"
  hypervisor_ip   = "192.168.200.252"
  vm_network_cidr = "10.255.2.0/24"
  vm_domain_name  = "vm.vhost-2"
}

// virtual machines on vhost_2
module "kube_1" {
  count           = 1
  source          = "git::https://github.com/tenzin-io/terraform-modules.git//libvirt/virtual-machine?ref=main"
  name            = "kube-0"
  datastore_name  = module.hypervisor.datastore_name
  network_id      = module.hypervisor.network_id
  base_volume_id  = module.hypervisor.base_volume_id
  cpu_count       = 5
  memory_size_mib = 40 * 1024   // gib
  disk_size_mib   = 1200 * 1024 // gib
  addresses       = ["10.255.2.10"]
  gpu_pci_bus     = "07"
}