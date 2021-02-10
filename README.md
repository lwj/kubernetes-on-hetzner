# kubernetes-on-hetzner

**Requirements:**

- Hetzner Cloud API token (obtain one from the 'Security' tab of your project)
- Terraform (v0.14.x)
- Ansible (v2.9.x)

---

## Usage

> :warning: Still largely untested and missing features - proceed with caution!

First, provision infrastructure:

```shell
terraform init
terraform apply
```

You'll be prompted to provide the following variables during `terraform apply`:

* `hcloud_token`: API token generated using the Hetzner Cloud Console.
* `location`: Location to provision the servers in ('nbg1', 'fsn1' or 'hel1').
* `workers`: Number of worker nodes to provision.

Finally, you'll be asked to confirm the changes by typing "yes". Once done, the required resources will be provisioned on Hetzner.

The following files are generated on completion:

* `hosts`: Ansible inventory file containing the IP addresses of the master and worker nodes.
* `cluster.pem`: PEM file containing a generated private key used to authenticate with the servers.

Run the `cluster.yml` playbook:

```shell
ansible-playbook cluster.yml --inventory hosts --user root --private-key cluster.pem
```

Once the playbook has ran to completion, the resulting kubeconfig will be stored as `~/.kube/config` on the control node, ready to be used by `kubectl`. If a kubeconfig already exists, it will be instead saved as `~/.kube/config-k3s`.

