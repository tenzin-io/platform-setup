# vhost-1
An Ansible playbook workspace to setup hypervisors.

## Helper
- Find the device ids of the GPU
```bash
# lspci -nn | grep -i nvidia
07:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] [10de:1b06] (rev a1)
07:00.1 Audio device [0403]: NVIDIA Corporation GP102 HDMI Audio Controller [10de:10ef] (rev a1)
```

## Setup Tailscale
- <https://tailscale.com/kb/1476/install-ubuntu-2404>

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
apt-get update
apt-get install -y tailscale
```
