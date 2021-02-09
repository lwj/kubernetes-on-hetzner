resource "hcloud_server" "kube_worker" {
  count = var.workers
  name        = format("worker%d", count.index + 1)
  server_type = "cx21"
  image       = "ubuntu-20.04"
  location    = var.location

  network {
    network_id = hcloud_network.kube.id
  }

  depends_on = [
    hcloud_network_subnet.kube
  ]
}
