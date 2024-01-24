# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

#Golang setup
export GOPATH=$HOME/Dev/go
export PATH=$HOME/bin:/usr/local/bin:$GOPATH/bin:$PATH

# K8s setup
export KUBECONFIG=$HOME/.kube/config
# add kubebuilder to path
export PATH=$PATH:/usr/local/kubebuilder/bin

# Nvim setup
alias v=nvim

# Homebrew setup
export PATH=$PATH:/opt/homebrew/bin

# Fix for GPG sign
export GPG_TTY=$(tty)

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyctx"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

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
  git kubectl docker macos golang svcat vscode keychain gpg-agent 
)

source $ZSH/oh-my-zsh.sh

# shell iterm2_shell_integration
# if [ ! -f ~/.config/iterm2/AppSupport/Scripts/iterm2_shell_integration.zsh ]; then
  # curl -L https://iterm2.com/shell_integration/zsh -o ~/.config/iterm2/AppSupport/Scripts/iterm2_shell_integration.zsh
# fi

# source ~/.config/iterm2/AppSupport/Scripts/iterm2_shell_integration.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# dotfiles
source ~/Dev/dotfiles/dotfiles.sh

#----- Asimov -----#
if [ -d ~/Dev/asimov ]; then
  source ~/Dev/asimov/sources/aliases
  source ~/Dev/asimov/sources/func
fi

#----- Autojump -----#
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

#----- Atuin shell history -----#
# Need to manually remove the arrow up keybinds
if command -v atuin > /dev/null && [ ! -f ~/.oh-my-zsh/custom/plugins/atuin.sh ]; then atuin init zsh > ~/.oh-my-zsh/custom/plugins/atuin.sh > ~/.oh-my-zsh/custom/plugins/atuin.sh; fi

if [ -f ~/.oh-my-zsh/custom/plugins/atuin.sh ]; then
  source ~/.oh-my-zsh/custom/plugins/atuin.sh 
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/Applications/google-cloud-sdk/path.zsh.inc' ]; then . '~/Applications/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/Applications/google-cloud-sdk/completion.zsh.inc' ]; then . '~/Applications/google-cloud-sdk/completion.zsh.inc'; fi

#----- Hugo -----##
if command -v hugo > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_hugo ]; then hugo completion zsh > ~/.oh-my-zsh/completions/_hugo; fi

# ---- K8s tooling ---- #
if command -v kubebuilder > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_kubebuilder ]; then kubebuilder completion zsh > ~/.oh-my-zsh/completions/_kubebuilder; fi
if command -v rustup > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_kustomize ]; then kustomize completion zsh > ~/.oh-my-zsh/completions/_kustomize; fi
if command -v rustup > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_kind ]; then kind completion zsh > ~/.oh-my-zsh/completions/_kind; fi

# Rust setup
if [ ! -f ~/.oh-my-zsh/completions/_rustup ]; then rustup completions zsh > ~/.oh-my-zsh/completions/_rustup; fi
if [ ! -f ~/.oh-my-zsh/completions/_cargo ]; then rustup completions zsh > ~/.oh-my-zsh/completions/_cargo; fi

# Zig setup
if command -v zig > /dev/null && [ ! -f ~/.oh-my-zsh/completions/_zig ]; then curl https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig > ~/.oh-my-zsh/completions/_zig; fi

## AWS CLI completions
complete -C '/opt/homebrew/bin/aws_completer' aws

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="~/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

