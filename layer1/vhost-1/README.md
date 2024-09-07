# README

An Ansible playbook to setup my machine, `vhost-1`

## Helper
- Find the device ids of the GPU
```bash
root@vhost-1:~# lspci -nn | grep -i nvidia
07:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] [10de:1b06] (rev a1)
07:00.1 Audio device [0403]: NVIDIA Corporation GP102 HDMI Audio Controller [10de:10ef] (rev a1)
```