# README
A Terraform configuration workspace to manage the virtual machines on `vhost-2`.

## Pre-reqs
These steps are needed prior to running Terraform provider `dmacvicar/libvirt`.
```
# The SSH config file needs to exist, otherwise panic
touch ~/.ssh/config

# If you have custom SSH keys then

# The `mkisofs` package must be installed
sudo apt-get update
sudp apt-get install -y mkisofs
```