local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"

# If you with to add context indicator to your ZSH just set the CTX env var and it will be displayed
ctx_prompt() {
    local ctx=$(kubectl config current-context 2>/dev/null)
    if [[ -n $ctx ]]; then
        local len=${#ctx}
        if [ $len -gt 8 ]; then
            ctx=${ctx:0:8}
        fi
        local ctxlabel="%{$fg[white]%} [$ctx]%{%f%}"
        echo $ctxlabel
    fi
}

PROMPT='${ret_status}$(ctx_prompt) %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
