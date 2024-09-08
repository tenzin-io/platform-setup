# README

## Nvidia
Helpful links
- Nvidia Kubernetes installation guide: <https://docs.nvidia.com/datacenter/cloud-native/kubernetes/install-k8s.html#install-k8s>.
- Linux driver downloads: <https://download.nvidia.com/XFree86/Linux-x86_64>.

### Nvidia node setup
- A set of notes during my Nvidia VM setup.
```
ESXi Host BIOS setup:
Enable SR-IOV
Enable Above 4G decoding
Enable iGPU and make it the primary graphics card

VM memory settings:
Reserve all guest memory (All locked)

VM advanced aarameters:
pciPassthru.use64bitMMIO	TRUE
pciPassthru.64bitMMIOSizeGB	64
pciPassthru.msiEnabled	FALSE
hypervisor.cpuid.v0	FALSE

# cat /etc/modprobe.d/nvidia.conf
options nvidia NVreg_OpenRmEnableUnsupportedGpus=1

# update-initramfs -u

Installing drivers:
apt-get install build-essential linux-headers-$(uname -r)

# cat /etc/modprobe.d/nvidia.conf
options nvidia NVreg_OpenRmEnableUnsupportedGpus=1
# update-initramfs -u

Found here: https://download.nvidia.com/XFree86/Linux-x86_64
./NVIDIA-Linux-x86_64-530.41.03.run -m=kernel-open  --disable-nouveau --silent
```

#### Example output
```
❯ nvidia-smi
Tue Apr 18 22:07:21 2023
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 530.41.03              Driver Version: 530.41.03    CUDA Version: 12.1     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                  Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf            Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 3060         Off| 00000000:03:00.0 Off |                  N/A |
|  0%   47C    P8               17W / 170W|      0MiB / 12288MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+

+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|  No running processes found                                                           |
+---------------------------------------------------------------------------------------+

❯ cat << 'eof' > gpu-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-operator-test
spec:
  restartPolicy: OnFailure
  containers:
  - name: cuda-vector-add
    image: "nvidia/samples:vectoradd-cuda10.2"
    resources:
      limits:
         nvidia.com/gpu: 1
eof

❯ k apply -f gpu-pod.yaml
pod/gpu-operator-test created

❯ k get pods -A
NAMESPACE            NAME                                       READY   STATUS              RESTARTS        AGE
default              gpu-operator-test                          0/1     ContainerCreating   0               5s
kube-system          calico-kube-controllers-567c56ff98-mzfjp   1/1     Running             2 (3h28m ago)   3h45m
kube-system          calico-node-lh2ls                          1/1     Running             3 (3h28m ago)   3h45m
kube-system          coredns-565d847f94-7hndh                   1/1     Running             2 (3h28m ago)   3h45m
kube-system          coredns-565d847f94-978md                   1/1     Running             2 (3h28m ago)   3h45m
kube-system          etcd-gpu-1                                 1/1     Running             3 (3h28m ago)   3h45m
kube-system          kube-apiserver-gpu-1                       1/1     Running             3 (3h28m ago)   3h45m
kube-system          kube-controller-manager-gpu-1              1/1     Running             3 (3h28m ago)   3h45m
kube-system          kube-proxy-sqmlj                           1/1     Running             3 (3h28m ago)   3h45m
kube-system          kube-scheduler-gpu-1                       1/1     Running             3 (3h28m ago)   3h45m
kube-system          nvidia-device-plugin-1681856802-gcqv8      1/1     Running             5 (3h30m ago)   3h31m
local-path-storage   local-path-provisioner-69945974f5-f9psb    1/1     Running             2 (3h28m ago)   3h45m

❯ k logs gpu-operator-test
[Vector addition of 50000 elements]
Copy input data from the host memory to the CUDA device
CUDA kernel launch with 196 blocks of 256 threads
Copy output data from the CUDA device to the host memory
Test PASSED
Done

```
