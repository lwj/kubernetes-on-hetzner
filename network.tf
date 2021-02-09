resource "hcloud_network" "kube" {
    name = "kubernetes"
    ip_range = "10.98.0.0/16"
}

resource "hcloud_network_subnet" "kube" {
  network_id    = hcloud_network.kube.id
  ip_range      = "10.98.1.0/24"
  type          = "server"
  network_zone  = "eu-central"
}
