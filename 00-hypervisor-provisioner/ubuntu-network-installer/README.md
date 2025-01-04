# netinst-1
An Ansible playbook to setup a machine that will help with provisioning baremetal hosts.

## The secrets.yaml
The secrets.yaml contain the WiFi name, password and the console password to set for provisioned baremetal hosts.

```yaml
wifi_name: 
wifi_password: 
wifi_band:

console_username:
console_password: 
automation_ssh_pubkey:
```

## Helper script
This is needed to get the `initrd` and `vmlinuz` files from inside the ISO and used by the iPXE script to run network installs.

```bash
# Create the www folder
test -d /var/www/ipxehttp || mkdir -p /var/www/ipxehttp
cd /var/www/ipxehttp

# Get the ISO file
wget https://releases.ubuntu.com/noble/ubuntu-24.04.1-live-server-amd64.iso

# The initrd and vmlinuz needs to be extracted out and served
mount -o loop ubuntu-24.04-live-server-amd64.iso /mnt
test -d ubuntu-24.04-live-server-amd64 || mkdir ubuntu-24.04-live-server-amd64
cp /mnt/casper/initrd /mnt/casper/vmlinuz ubuntu-24.04-live-server-amd64
```
