resource "hcloud_network" "kube" {
  name     = "kubernetes"
  ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "kube" {
  network_id   = hcloud_network.kube.id
  ip_range     = "10.0.1.0/24"
  type         = "server"
  network_zone = "eu-central"
}
