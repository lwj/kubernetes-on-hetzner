resource "tls_private_key" "kube" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "kube" {
  name = "kubernetes"
  public_key = tls_private_key.kube.public_key_openssh
}