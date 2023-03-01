# Runs the initial configuration installation
.PHONY: install
install:
	source zsh/.zshrc; dotfiles apply
