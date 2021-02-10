resource "hcloud_server" "kube_worker" {
  count       = var.workers
  name        = format("worker%d", count.index + 1)
  server_type = var.worker_type
  image       = "ubuntu-20.04"
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.kube.id]

  network {
    network_id = hcloud_network.kube.id
  }

  depends_on = [
    hcloud_network_subnet.kube
  ]
}
