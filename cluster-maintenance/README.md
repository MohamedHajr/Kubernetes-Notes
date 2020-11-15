# Cluster Maintenance

### what is the time kuberentes wait for a pod to come back online?
`kube-controller-manager --pod-evection-timeout=5m0s` and defaults to 5 mins

### What is a safe way to do an upgrad and taking down a node?
`drain` the node to move workloads to other nodes in the cluster(gracefully terminated and recreated on anothera)
then `uncordon` the node so the pods can be scheduled on it

### How can prevent any scheduling on a specifc node?
by cordoning the node `kubectl cordon node-1`

### what is the software versoning that kubernetes follows?
Major, Minor Batch v1.11.3
- 1 -> major
- 11 -> minor
- 3 -> patch

### what are the components in the controlplane that has different release cycles and verions?
- ETCD cluster
- CoreDNS

### What is the recommended way to upgrade kubernetes components?
upgrading one minor version at a time.

### What are the possible version differences in the controlplane components?
![versions](./images/versions.png)

### What is the way to upgrade a kubernetes cluster deployed using kubeadm?
- upgrading kubeadm `apt-get upgrade -y kubeadm=1.12.0-00`
- applying the upgrade to the cluster using kubeadm `kubeadm upgrade apply v1.12.0`
- upgrading manually each kubelet on any node  
    - draining if it has workloads `kubectl drain node-1`
    - upgrade kubeadm `apt-get upgrade -y kubeadm=1.12.0-00`
    - upgrading the kublet `apt-get upgrade -y kubelet-1.12.0-00`
    - upgrading the node configuration `kubeadm upgrade node config --kubelet-version v1.12.0`
    - `systemctl restart kubelet`

### How can we take backups for our kuberentes cluster?
- saving all resources to a yaml file `kubectl get all -A -o yaml > all-resources.yaml` for a few resource groups
- using Velero to take backups from the cluster using the API

### How can we backup ETCD?
- backing up the `--data-dir` that we specified when configuring ETCD
- taking a snapshot from the ETCD database by using the built in `ETCDCTL_API=3 etcdctl \
 snapshot save snapshot.db`

### How to restore an ETCD cluster snapshot?
![etcd-backup](./images/etcd.png)

### what are the mandatory options when using `etcdctl` for a TLS enabled ETCD?
- `--cacert`  --> verify certificates of TLS-enabled secure servers using this CA bundle

- `--cert`    --> identify secure client using this TLS certificate file

- `--endpoints=[127.0.0.1:2379]`   -->       This is the default as ETCD is running on master node and exposed on localhost 2379.

- `--key`        --> identify secure client using this TLS key file

### What happens when we restore ETCD from a snapshot?
it inilaizes a new cluster configuration and configure the memebers of ETCD as new memebers to a new cluster, to prevent a new memeber to join an exisiting cluster

### How to double check if an etcdctl command is working before running it?
by applying the `memeber list` options on it
