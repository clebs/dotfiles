# Dotfiles

This repository contains all dotfiles and configurations for my personal development setup.

## Installation

To install the repo and the files run:
```bash
mkdir ~/Dev && cd ~/Dev && git clone git@github.com:clebs/dotfiles.git && cd dotfiles && make install
```

## Apply/Backup configs

Once installed, the zsh profile contains 2 commands to apply and backup:
- `dotfiles apply`:  applies configuration files from the repository on the local machine.
- `dotfiles backup`: backs up the config on the local machine into the repository as a new commit to master.

