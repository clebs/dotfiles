# Runs the initial configuration installation
.PHONY: install
install:
	source zsh/.zprofile; dotfiles apply
