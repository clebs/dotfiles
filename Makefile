# Allow passing args instead of evaluating them as more goals.
# %:: in the end silences warnings of no matching goal.
cmd := $(firstword $(MAKECMDGOALS))
args := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))# base modules

.PHONY: install
install:
	stow atuin ghostty git nvim tmux zsh -t ~

# Hyprland
.PHONY: hyprland
hyprland: install
	stow hyprland -t ~

# Nix:
# Can not use stow because nix does not like symlinks
#
# If not empty: copy from the target to adopt changes in the repo.
# It is safe: source is in version control.
#
# If empty: we can safely copy everything
#
# Optionally if "force" arg is passed, we overwrite everthing on the target regardless.
.PHONY: nixos
nixos:
	@if [ "$(shell ls -A "/etc/nixos")" ] && [ ! "$(args)" = "force" ]; then \
		echo "Target not empty: copying from target"; \
		cp -r /etc/nixos/* nix/nixos; \
	else \
		echo "Target empty or force enabled: copying to target"; \
		cp -r nix/nixos/* /etc/nixos; \
	fi

.PHONY: nixdarwin
nixdarwin:
	@if [ "$(shell ls -A "/etc/nix-darwin")" ] && [ ! "$(args)" = "force" ]; then \
		echo "Target not empty: copying from target"; \
		cp -r /etc/nix-darwin/* nix/darwin; \
	else \
		echo "Target empty or force enabled: copying to target"; \
		cp -r nix/darwin/* /etc/nix-darwin; \
	fi

%::
	@True
