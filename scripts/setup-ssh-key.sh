#!/bin/bash
set -x
set -e

test -e actions || ssh-keygen -t ed25519 -f actions -N ""
chmod 0600 actions

test -e actions-cert.pub || vault write -field=signed_key ssh/sign/sysuser-role public_key=@actions.pub > actions-cert.pub
ssh-keygen -Lf actions-cert.pub
