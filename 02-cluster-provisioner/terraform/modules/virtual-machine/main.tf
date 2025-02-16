terraform {
  required_version = "~> 1.9"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

resource "libvirt_cloudinit_disk" "cloudinit_iso" {
  name = "${var.name}-cloudinit-seed.iso"
  user_data = templatefile("${path.module}/templates/cloud-init.cfg", {
    hostname               = var.name
    launch_script          = var.launch_script
    automation_user        = var.automation_user
    automation_user_pubkey = var.automation_user_pubkey
  })
  pool = var.datastore_name
}

resource "libvirt_volume" "root_disk" {
  name             = "${var.name}-root-disk.qcow2"
  base_volume_name = var.base_volume.name
  base_volume_pool = var.base_volume.pool
  size             = var.disk_size_mib * 1024 * 1024 // size must be in bytes
  pool             = var.datastore_name
}

resource "libvirt_volume" "data_disk" {
  for_each = var.data_disks
  name     = "${var.name}-${basename(each.key)}-disk.qcow2"
  size     = each.value.disk_size_mib * 1024 * 1024 // size must be in bytes
  pool     = var.datastore_name
}

resource "libvirt_domain" "machine" {
  name   = var.name
  memory = var.memory_size_mib
  vcpu   = var.cpu_count
  cpu {
    mode = "host-passthrough"
  }
  machine = "q35"

  firmware = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  nvram {
    file = "/var/lib/libvirt/qemu/nvram/${var.name}-VARS.fd"
  }

  xml {
    xslt = file("${path.module}/files/base-transform.xslt")
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  network_interface {
    bridge   = "br0"
    hostname = var.name
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit_iso.id
  disk {
    volume_id = libvirt_volume.root_disk.id
  }

  lifecycle {
    ignore_changes = [
      cloudinit
    ]
  }
}
