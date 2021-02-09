resource "local_file" "ansible_inventory" {
  content = templatefile("hosts.tmpl",
    {
      master-ip  = hcloud_server.kube_master.ipv4_address
      worker-ips = hcloud_server.kube_worker.*.ipv4_address
    }
  )
  filename = "hosts"
}
