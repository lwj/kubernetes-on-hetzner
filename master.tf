resource "hcloud_server" "kube_master" {
  name        = "master"
  server_type = "cx11"
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
