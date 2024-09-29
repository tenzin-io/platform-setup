resource "libvirt_network" "network" {
  name      = "vm-network"
  mode      = "route"
  bridge    = "virbr1"
  autostart = true
  domain    = "virtual.lan"
  addresses = ["10.255.1.0/24"]
  dhcp {
    enabled = true
  }

  dns {
    enabled    = true
    local_only = false
  }
}

resource "libvirt_pool" "datastore" {
  name = "datastore"
  type = "dir"
  path = "/var/lib/libvirt/machines"
}
