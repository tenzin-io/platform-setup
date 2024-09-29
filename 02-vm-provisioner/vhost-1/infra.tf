resource "libvirt_network" "network" {
  name      = "vm-network"
  mode      = "route"
  bridge    = "virbr1"
  autostart = true
  domain    = "vm.vhost-1"
  addresses = ["10.255.1.0/24"]

  dhcp {
    enabled = true
  }

  dns {
    enabled    = true
    local_only = false

    hosts {
      hostname = "metallb"
      ip       = "10.255.1.254"
    }
  }

  dnsmasq_options {
    options {
      option_name = "localise-queries"
    }

    options {
      option_name  = "local"
      option_value = "/vm.vhost-1/"
    }

    options {
      option_name  = "listen-address"
      option_value = "10.255.1.1,192.168.200.251"
    }

    options {
      option_name  = "address"
      option_value = "/gateway.vm.vhost-1/10.255.1.1"
    }

    options {
      option_name  = "dhcp-option"
      option_value = "option:domain-search,vm.vhost-1"
    }
  }
}

resource "libvirt_pool" "datastore" {
  name = "datastore"
  type = "dir"
  path = "/var/lib/libvirt/machines"
}
