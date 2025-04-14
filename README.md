# README
A repository to setup my homelab infrastructure.

## My OS choice
- [Ubuntu Server](https://ubuntu.com/download/server)

## Console setup
The below script setups my console server, a simple server from which I run my scripts or GitHub actions.

```bash
#!/bin/bash

## os packages
sudo apt-get update
sudo apt-get install -y git vim tmux mosh python3-venv

## setup python venv
if [[ ! -d ~/.venv ]]
then
  mkdir ~/.venv
  python3 -m venv ~/.venv
fi

source ~/.venv/bin/activate
echo 'source ~/.venv/bin/activate' >> ~/.bashrc
pip install ansible

## setup gitconfig
cat <<EOF > ~/.gitconfig
[user]
  name = Tenzin Lhakhang
  email = 2402007+tlhakhan@users.noreply.github.com
EOF

## setup ssh config for homelab machine login
cat <<EOF > ~/.ssh/config
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/tenzin.key
    User git

# Default key for all homelab local hosts
Host *.local
    IdentityFile ~/.ssh/tenzin.key
    User ubuntu
    IdentitiesOnly yes
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF

## tmux conf setup
cat <<'EOF' > ~/.tmux.conf
bind r source-file ~/.tmux.conf \; display "Reloaded!"
set -g mouse off
set -g default-terminal "xterm"

# bar style
set -g status-style fg=white,bold,bg=black
setw -g window-status-style fg=cyan,bg=black
setw -g window-status-current-style fg=white,bold,bg=red

# clock-style
set -g status-right "#[fg=cyan]%A, %b %d %Y %I:%M %p"

# for pane
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
EOF

## vim conf setup
cat << 'EOF' > ~/.vimrc
set nocompatible             " Use full Vim features (not Vi compatibility)
syntax enable                " Turn on syntax highlighting
filetype plugin on           " Enable filetype detection and plugin support
set number                   " Show line numbers
set path+=**                 " Search subdirectories when looking for files
set wildmenu                 " Enable better tab-completion menu
let g:netrw_banner=0         " no annoying banner
let g:netrw_browse_split=4   " open files in previous window
let g:netrw_altv=1           " vertical splits open on the right
let g:netrw_liststyle=3      " show files in columns
EOF
```

