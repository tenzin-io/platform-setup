# README
An Ansible playbook to setup hypervisors.

## Usage
- Copy `vars.yaml` to `overrides.yaml`
- Update `overrides.yaml` to match machine settings
- Execute `main.yaml` to start the playbook

## Setup Tailscale
- <https://tailscale.com/kb/1476/install-ubuntu-2404>

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
apt-get update
apt-get install -y tailscale
```
