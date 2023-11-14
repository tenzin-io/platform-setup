test -e private_key || ssh-keygen -t ed25519 -f private_key -N ""
chmod 0600 private_key
vault write -field=signed_key ssh/sign/packer-role public_key=@private_key.pub > private_key-cert.pub
ssh-keygen -Lf private_key-cert.pub
