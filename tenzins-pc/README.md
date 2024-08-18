# README

An Ansible playbook to setup my machine, `tenzins-pc`.

## Helper
- Find the device ids of the GPU
```bash
# lspci -nn | grep -i nvidia
06:00.0 VGA compatible controller [0300]: NVIDIA Corporation AD103 [GeForce RTX 4070 Ti SUPER] [10de:2705] (rev a1)
06:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:22bb] (rev a1)
```