#!/bin/bash

# Perform retries if failing download
echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80-retries

### Setup Kubernetes system prep

apt-get install -y ansible-core

git clone https://github.com/tenzin-io/setup-kubernetes.git
cd /setup-kubernetes/sysprep-node

cat <<'eof' > overrides.yaml
docker_hub_user: "${docker_hub_user}"
docker_hub_token: "${docker_hub_token}"
eof

ansible-playbook main.yaml

### Setup Kubernetes node

cd /setup-kubernetes/cluster-node

cat <<'eof' > overrides.yaml
# kubernetes
skip_phase_mark_control_plane: True
cluster_name: "${cluster_name}"
eof

ansible-playbook main.yaml

### Install Terraform

apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update && apt-get install -y terraform

### Setup platform components
cd /setup-kubernetes/platform-addons
cat <<'eof' > terraform.tfvars
cluster_name = "${cluster_name}"
vault_address = "${vault_address}"
vault_username = "${vault_username}"
vault_password = "${vault_password}"
eof

terraform init && terraform apply -auto-approve
