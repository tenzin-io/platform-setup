resource "libvirt_volume" "ubuntu_cloud_image" {
  source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  name   = "noble-server-cloudimg-amd64.img"
  pool   = libvirt_pool.cloud_images.name
  format = "qcow2"
}

data "vault_generic_secret" "dockerhub" {
  path = "secrets/docker-hub/tenzinbot"
}

module "kubernetes" {
  count          = 1
  source         = "./modules/virtual-machine"
  name           = "kubernetes-1"
  datastore_name = libvirt_pool.datastore.name

  automation_user        = var.vm_automation_user
  automation_user_pubkey = var.vm_automation_user_pubkey

  base_volume = {
    pool = libvirt_pool.cloud_images.name
    name = libvirt_volume.ubuntu_cloud_image.name
    id   = libvirt_volume.ubuntu_cloud_image.id
  }

  cpu_count       = 6
  memory_size_mib = 4 * 1024   // gib
  disk_size_mib   = 250 * 1024 // gib

  has_gpu_passthru = true
  gpu_pci_bus      = "01"

  gateway_address = "192.168.2.1"
  ip_address      = "192.168.2.100"

  launch_script = templatefile("${path.module}/templates/kubernetes_setup_script.sh", {

    cluster_name                   = "kubernetes-1"
    control_plane_endpoint_name    = "kubernetes-1.local"
    control_plane_endpoint_address = "192.168.2.100"

    vault_address  = var.vault_address
    vault_username = var.vault_username
    vault_password = var.vault_password

    docker_hub_user  = data.vault_generic_secret.dockerhub.data["username"]
    docker_hub_token = data.vault_generic_secret.dockerhub.data["personal_access_token"]
  })
}
