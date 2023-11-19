#!/bin/bash

export VAULT_ADDR=https://vault.tenzin.io

VAULT_TOKEN=${VAULT_TOKEN:-""}
if [ -z "$VAULT_TOKEN" ]; then
  read -p "Enter VAULT_TOKEN: " user_input
  VAULT_TOKEN="$user_input"
fi
export VAULT_TOKEN

# for ed25519 key
if [[ -e "$HOME/.ssh/id_ed25519.pub" ]]
then
  vault write -field=signed_key ssh/sign/packer-role public_key=@$HOME/.ssh/id_ed25519.pub > $HOME/.ssh/id_ed25519-cert.pub
  ssh-keygen -Lf $HOME/.ssh/id_ed25519-cert.pub
  exit 0
fi

# for rsa key
if [[ -e "$HOME/.ssh/id_rsa.pub" ]]
then
  vault write -field=signed_key ssh/sign/packer-role public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub
  ssh-keygen -Lf $HOME/.ssh/id_rsa-cert.pub
  exit 0
fi
