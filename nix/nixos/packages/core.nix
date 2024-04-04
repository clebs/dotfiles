{pkgs, unstable, ...}: with pkgs; 
[
  unstable.neovim
  atuin
  curl
  gcc
  neofetch
  autojump
  git
  fd
  fzf
  tree
  tldr
  jq
  htop
  gnupg
  ripgrep
  stow
  tmux
  wget
  zsh
  # Choose clipboard based on display server
  # xclip
  wl-clipboard
]
