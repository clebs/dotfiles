# Do not show any greeting
set --universal --erase fish_greeting
function fish_greeting; end

# Oh My Fish
if not test -d ~/.local/share/omf
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    omf install robbyrussell
    omf install https://github.com/jhillyerd/plugin-git
    omf install https://github.com/2m/fish-history-merge

    omf theme robbyrussell
    omf reload
end

# Homebrew
if test -d "/opt/homebrew"
    set -gx HOMEBREW_PREFIX "/opt/homebrew";
    set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar";
    set -gx HOMEBREW_REPOSITORY "/opt/homebrew";
    set -q PATH; or set PATH ''; set -gx PATH "/opt/homebrew/bin" "/opt/homebrew/sbin" $PATH;
    set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/opt/homebrew/share/man" $MANPATH;
    set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH;
end

# Exported variables
if isatty
    set -x GPG_TTY (tty)
end

# Editor
set -gx EDITOR nvim

# PATH
set -q GOPATH; or set -gx GOPATH $HOME/Dev/go;
contains $GOPATH/bin $fish_user_paths; or set -Ua fish_user_paths $GOPATH/bin
contains $HOME/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/bin
contains /usr/local/kubebuilder/bin $fish_user_paths; or set -Ua fish_user_paths /usr/local/kubebuilder/bin

#----- Autojump -----#
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish

# Functions
alias v='nvim'
alias gs='git status -s'
alias l='la'
alias k='kubectl'

# Oh My Fish
function __omf_install -d "Install Oh My Fish"
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
end

function __omf_plugins -d "Install Oh My Fish plugins and theme"
    omf install robbyrussell
    omf install https://github.com/jhillyerd/plugin-git
    omf install https://github.com/2m/fish-history-merge

    omf theme robbyrussell
    omf reload
end
