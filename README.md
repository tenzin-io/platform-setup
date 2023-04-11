# README
A repository to setup my control machine in my home lab.

## Pre-requisites
```
pip install boto3 botocore
ansible-galaxy collection install amazon.aws
```

## Usage
Setup my preferences
```
./main.yaml -t prefs
```

Setup my SSH private key
```
./main.yaml -t ssh
```

## Appendix
### Install Ansible on Debian 11
```
apt-get update
apt-get install -y python3-pip

pip3 install --upgrade pip

pip install --upgrade ansible
ansible-galaxy collection install --timeout 180 community.general
```
