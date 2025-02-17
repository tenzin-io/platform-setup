resource "libvirt_pool" "datastore" {
  name = "local-datastore"
  type = "dir"
  target {
    path = "/data/local-datastore"
  }
}

resource "libvirt_pool" "cloud_images" {
  name = "local-cloud-images"
  type = "dir"
  target {
    path = "/data/local-cloud-images"
  }
}
