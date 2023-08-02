# README
A repository to setup my machine preferences using Ansible.

## Usage
```
ansible-playbook main.yaml
```

## Appendix
### Install Ansible on Debian
```
apt-get update
apt-get install -y python3-pip

pip install --upgrade pip
pip install --upgrade ansible

ansible-galaxy collection install --timeout 180 community.general
```
