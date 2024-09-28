# README
This Ansible playbook role that helps setup a Kubernetes cluster.

## Inventory groups
- `bootstrap_node` - The initial node to setup a Kubernetes cluster.
- `control_plane` - The nodes that will join the cluster as controlplane nodes.
- `worker_nodes` - The nodes that will join the cluster to host regular workloads.

**Supported OSes**
- Debian 12 (bookworm)

## Example output
```
# kubectl get nodes
NAME         STATUS   ROLES           AGE   VERSION
dev-kube-1   Ready    control-plane   24h   v1.29.1-eks-95a4fb9
dev-kube-2   Ready    <none>          60s   v1.29.1-eks-95a4fb9

# kubectl get all -A
NAMESPACE     NAME                                           READY   STATUS    RESTARTS   AGE
kube-system   pod/calico-kube-controllers-7ddc4f45bc-vbrbf   1/1     Running   0          24h
kube-system   pod/calico-node-478pj                          1/1     Running   0          24h
kube-system   pod/calico-node-zzdxl                          1/1     Running   0          115s
kube-system   pod/coredns-76f75df574-lwq88                   1/1     Running   0          24h
kube-system   pod/coredns-76f75df574-nk826                   1/1     Running   0          24h
kube-system   pod/etcd-dev-kube-1                            1/1     Running   0          24h
kube-system   pod/kube-apiserver-dev-kube-1                  1/1     Running   0          24h
kube-system   pod/kube-controller-manager-dev-kube-1         1/1     Running   0          24h
kube-system   pod/kube-proxy-84htw                           1/1     Running   0          115s
kube-system   pod/kube-proxy-pzbkh                           1/1     Running   0          24h
kube-system   pod/kube-scheduler-dev-kube-1                  1/1     Running   0          24h

NAMESPACE     NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes   ClusterIP   10.254.0.1    <none>        443/TCP                  24h
kube-system   service/kube-dns     ClusterIP   10.254.0.10   <none>        53/UDP,53/TCP,9153/TCP   24h

NAMESPACE     NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/calico-node   2         2         2       2            2           kubernetes.io/os=linux   24h
kube-system   daemonset.apps/kube-proxy    2         2         2       2            2           kubernetes.io/os=linux   24h

NAMESPACE     NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/calico-kube-controllers   1/1     1            1           24h
kube-system   deployment.apps/coredns                   2/2     2            2           24h

NAMESPACE     NAME                                                 DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/calico-kube-controllers-7ddc4f45bc   1         1         1       24h
kube-system   replicaset.apps/coredns-76f75df574                   2         2         2       24h
```

### Component release pages
- <https://containerd.io/downloads/#releases>
- <https://github.com/opencontainers/runc/releases>
- <https://github.com/containernetworking/plugins/releases>
- <https://github.com/projectcalico/calico/releases>
- <https://github.com/aws/eks-distro/releases>
- <https://github.com/kubernetes-sigs/cri-tools/releases>
