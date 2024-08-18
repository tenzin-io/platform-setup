# README
An Ansible playbook to setup a machine that will help with performing automated network installation of bare-metal hosts.

## Helper scripts

```bash
# Create the www folder
test -d /var/www/ipxehttp || mkdir -p /var/www/ipxehttp
cd /var/www/ipxehttp

# Get the ISO file
wget http://tenzins-mini.lan:8080/ubuntu-24.04-live-server-amd64.iso

# The initrd and vmlinuz needs to be extracted out and served
mount -o loop ubuntu-24.04-live-server-amd64.iso /mnt
test -d ubuntu-24.04-live-server-amd64 || mkdir ubuntu-24.04-live-server-amd64
cp /mnt/casper/initrd /mnt/casper/vmlinuz ubuntu-24.04-live-server-amd64

```