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
  count  = 1
  source = "./modules/virtual-machine"
  name   = "kubernetes-1"

  automation_user        = var.vm_automation_user
  automation_user_pubkey = var.vm_automation_user_pubkey

  # vm settings
  cpu_count       = 7
  memory_size_mib = 48 * 1024  // gib
  disk_size_mib   = 250 * 1024 // gib
  datastore_name  = libvirt_pool.datastore.name
  base_volume = {
    pool = libvirt_pool.cloud_images.name
    name = libvirt_volume.ubuntu_cloud_image.name
    id   = libvirt_volume.ubuntu_cloud_image.id
  }

  # gpu settings
  has_gpu_passthru = true
  gpu_pci_bus      = "01"

  # static ip seeings
  gateway_address = "192.168.2.1"
  ip_address      = "192.168.2.100"

  # launch_script = templatefile("${path.module}/templates/launch_script.sh", {})

  launch_script = templatefile("${path.module}/templates/kubernetes_setup_script.sh", {

    cluster_name = "kubernetes-1"

    # for uploading kubeconfig to vault
    vault_address  = var.vault_address
    vault_username = var.vault_username
    vault_password = var.vault_password

    # for authentiated registry access, more image pulls
    docker_hub_user  = data.vault_generic_secret.dockerhub.data["username"]
    docker_hub_token = data.vault_generic_secret.dockerhub.data["personal_access_token"]
  })
}
