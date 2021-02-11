resource "local_file" "ansible_inventory" {
  filename = "hosts"
  content = templatefile("hosts.tmpl",
    {
      master-ip  = hcloud_server.kube_master.ipv4_address
      worker-ips = hcloud_server.kube_worker.*.ipv4_address
      network-id = hcloud_network.kube.id
    }
  )
}

resource "local_file" "cluster_pem" { 
  filename = "cluster.pem"
  content = tls_private_key.kube.private_key_pem
  file_permission = 0400
}