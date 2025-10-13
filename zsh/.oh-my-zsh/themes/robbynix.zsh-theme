nix-prompt() {
  if [ -n "$NIX_SHELL_PROMPT" ]; then
    echo "❄️ "
    return 0
  fi

  LAST_CMD=$(tail -1  ~/.zsh_history | awk -F ';' '{print $2}')
  if [[ $LAST_CMD =~ "nix shell" ]]; then
    export NIX_SHELL_PROMPT=1
    echo "❄️ "
    return 0
  fi
}


flake=$(nix-prompt)
PROMPT="%(?:%{$flake%}%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

