# zmodload zsh/zprof  

# Nix setup
export PATH=$PATH:/run/current-system/sw/bin

#Golang setup
export GOPATH=$HOME/Dev/go
export PATH=$HOME/bin:/usr/local/bin:$GOPATH/bin:$PATH

# K8s setup
export KUBECONFIG=$HOME/.kube/config
# add kubebuilder to path
export PATH=$PATH:/usr/local/kubebuilder/bin

# Nvim setup
alias v=nvim
export EDITOR='nvim'

# Java setup is managed by Nix: get the store path for the JRE dynamically so it works with updates
export JAVA_HOME=${$(readlink /run/current-system/sw/bin/java)%'/bin/java'}

# Homebrew setup
export PATH=$PATH:/opt/homebrew/bin:/opt/homebrew/sbin

# Fix for GPG sign
export GPG_TTY=$(tty)

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Aliases
# Do not alias stndard cat, things break...
alias ccat='highlight -O ansi --force=shellscript'
# docker aliased to podman
alias docker='podman'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbynix"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

#----- Completions -----##
# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
zstyle ':completion:*' use-cache on

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git golang kubectl podman keychain atuin autojump
)

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

#----- Asimov -----#
if [ -d ~/Dev/asimov ]; then
  source ~/Dev/asimov/sources/aliases
  source ~/Dev/asimov/sources/func
fi

if [  ! -d ~/.oh-my-zsh/completions ]; then
  mkdir ~/.oh-my-zsh/completions
fi

#----- Atuin shell history -----#
# Need to manually remove the arrow up keybinds
if command -v atuin > /dev/null && [ ! -f ~/.oh-my-zsh/custom/plugins/atuin/atuin.plugin.zsh ]; then
  mkdir -p ~/.oh-my-zsh/custom/plugins/atuin
  atuin init zsh > ~/.oh-my-zsh/custom/plugins/atuin/atuin.plugin.zsh
fi

#----- Hugo -----##
if command -v hugo > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_hugo ]; then hugo completion zsh > ~/.oh-my-zsh/completions/_hugo; fi

# ---- K8s tooling ---- #
if command -v kubebuilder > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_kubebuilder ]; then kubebuilder completion zsh > ~/.oh-my-zsh/completions/_kubebuilder; fi
if command -v kustomize > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_kustomize ]; then kustomize completion zsh > ~/.oh-my-zsh/completions/_kustomize; fi
if command -v kind > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_kind ]; then kind completion zsh > ~/.oh-my-zsh/completions/_kind; fi

# Rust setup
if command -v rustup > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_rustup ]; then rustup completions zsh > ~/.oh-my-zsh/completions/_rustup; fi
if command -v rustup > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_cargo ]; then rustup completions zsh > ~/.oh-my-zsh/completions/_cargo; fi

# Zig setup
if command -v zig > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_zig ]; then curl https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig > ~/.oh-my-zsh/completions/_zig; fi

# Ruby setup
if command -v rbenv &> /dev/null; then eval "$(rbenv init - zsh)"; fi

## AWS CLI completions
# complete -C '/opt/homebrew/bin/aws_completer' aws

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="~/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

source $ZSH/oh-my-zsh.sh

# zprof
