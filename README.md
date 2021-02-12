# kubernetes-on-hetzner

## What does this project do?

1. Provisions infrastructure on Hetzner Cloud
2. Bootstraps a Kubernetes cluster using K3s
3. Deploys the Cloud Controller Manager for Hetzner Cloud
4. Deploys the Container Storage Interface driver for Hetzner Cloud

**Requirements:**

- Hetzner Cloud API token (obtain one from the 'Security' tab of your project)
- Terraform (v0.14.x)
- Ansible (v2.9.x)

---

## Usage

First, provision infrastructure:

```shell
terraform init
terraform apply
```

You'll be prompted to provide the following variables during `terraform apply`:

* `hcloud_token`: API token generated using the Hetzner Cloud Console.
* `location`: Location to provision the servers in ('nbg1', 'fsn1' or 'hel1').
* `workers`: Number of worker nodes to provision.

You can also specify an optional `worker-type` variable to change the server type used for provisioning worker nodes. By default, `cx21` instances are used. Server types are listed [here](https://www.hetzner.com/cloud).

Finally, you'll be asked to confirm the changes by typing "yes". Once done, the required resources will be provisioned on Hetzner.

The following files are generated on completion:

* `hosts`: Ansible inventory file containing the IP addresses of the master and worker nodes.
* `cluster.pem`: PEM file containing a generated private key used to authenticate with the servers.

Run the `cluster.yml` playbook:

```shell
ansible-playbook cluster.yml --inventory hosts --user root --private-key cluster.pem
```

You will again be prompted for a Hetzner Cloud API token. This is used to create the controller for provisioning cloud resources.

Once the playbook has ran to completion, the resulting kubeconfig will be stored as `~/.kube/config` on the control node, ready to be used by `kubectl`. If a kubeconfig already exists, it will be instead saved as `~/.kube/config-k3s`.

## Provisioning Cloud Resources

Once you've set up the cluster, you'll be able to provision Hetzner Cloud resources using the Cloud Controller Manager and Container Storage Interface driver.

For more information, read the official docs:

* [Cloud Controller Manager for Hetzner Cloud](https://github.com/hetznercloud/csi-driver)
* [Container Storage Interface driver for Hetzner Cloud](https://github.com/hetznercloud/hcloud-cloud-controller-manager)

### Load Balancers

You can provision a load balancer by creating a service of type `LoadBalancer` with the `load-balancer.hetzner.cloud/location` annotation. This should be set to the same location you provisioned the servers under ('nbg1', 'fsn1' or 'hel1'). As we've set up a private network for our servers, you can also use the `load-balancer.hetzner.cloud/use-private-ip` annotation to route traffic through it.

Example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: example-svc
  annotations:
    load-balancer.hetzner.cloud/location: nbg1
    load-balancer.hetzner.cloud/use-private-ip: "true"
spec:
  selector:
    app: example
  ports:
    - port: 80
      targetPort: 8080
  type: LoadBalancer
```

### Volumes

The CSI driver enables you to provision volumes from within Kubernetes using the created `hcloud-volumes` storage class. Just create a `PersistentVolumeClaim` and attach it to a pod.

Example:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: hcloud-volumes
---
kind: Pod
apiVersion: v1
metadata:
  name: example-pod
spec:
  containers:
    - name: example
      image: hello-world
      volumeMounts:
      - mountPath: "/data"
        name: example-volume
  volumes:
    - name: example-volume
      persistentVolumeClaim:
        claimName: example-pvc
```