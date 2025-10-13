# Stow commands to link everything based on the environment

# base modules
.PHONY: install
install:
	stow atuin ghostty git nvim omz tmux zsh -t ~

# Hyprland
.PHONY: hyprland
hyprland: install
	stow hypr waybar wofi -t ~

# Still WIP: figure out how to keep hardware config without checking it in on multiple machines (probably stow ignore)
# NixOS:
# .PHONY: nixos
# nixos:
	# stow nix/nixos -t /etc/nixos

# Nix Darwin:
# .PHONY: nixdarwin
# nixdarwin:
	# stow nix/darwin -t /etc/nix-darwin
