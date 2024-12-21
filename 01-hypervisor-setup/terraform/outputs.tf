output "base_cloud_image" {
  value = {
    pool_name = libvirt_pool.cloud_images.name
    name      = libvirt_volume.ubuntu_cloud_image.name
    id        = libvirt_volume.ubuntu_cloud_image.id
  }
}

output "hypervisor_connection" {
  value = {
    hostname     = local.hypervisor_hostname
    ssh_user     = local.hypervisor_ssh_user
    ssh_key_name = local.hypervisor_ssh_key_name
  }
}