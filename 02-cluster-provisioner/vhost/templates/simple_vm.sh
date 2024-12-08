#!/bin/bash

# setup tailscale
install tailscale - https://tailscale.com/download/linux
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
apt-get update
apt-get install -y tailscale

# join tailnet
%{ if length(tailscale_auth_key) > 0 }
tailscale up --authkey ${tailscale_auth_key}
%{ endif }