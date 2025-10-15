# Dotfiles

This repository contains all dotfiles and configurations for my personal development setup.

## Prerequisites
The following programs need to be installed to be able to correctly install the dotfiles.

- git
- zsh
- stow
- oh-my-zsh (remove the .zshrc it generates after installing it)

Usually it is best to first use `make nixos` or `make nixdarwin` and build the system to have all packages available.

## Installation

To install the repo and the files run:
```bash
mkdir ~/Dev && cd ~/Dev && git clone git@github.com:clebs/dotfiles.git && cd dotfiles && make install
```
This installs the essential dotfiles. For specific modules see the [Makefile](./Makefile).
