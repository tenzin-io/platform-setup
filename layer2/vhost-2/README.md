# vhost-2

An Ansible playbook to setup my machine, `vhost-2`

## Helper
- Find the device ids of the GPU
```bash
# lspci -nn | grep -i nvidia
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA106 [GeForce RTX 3060 Lite Hash Rate] [10de:2504] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation GA106 High Definition Audio Controller [10de:228e] (rev a1)
```