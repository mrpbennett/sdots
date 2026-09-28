# ~/.bashrc

# Interactive shells only
[[ $- != *i* ]] && return

# History
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Useful shell options
shopt -s checkwinsize

# SSH terminal
if [[ -n "${SSH_CONNECTION:-}${SSH_TTY:-}" ]]; then
    export TERM=xterm-256color
fi

# Aliases
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias ll='ls -alF'
alias la='ls -A'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'

alias v='nvim'
alias cat='bat'
alias e='exit'
alias lzg='lazygit'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ff='nvim "$(fzf --preview '\''bat --style=numbers --color=always {}'\'')"'

# Yazi
function y() {
    local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi "$@" --cwd-file="$tmp"
    if IFS= read -r -d '' cwd < "$tmp"; then
        [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
    fi
    rm -f "$tmp"
}

# Mise
if command -v mise &>/dev/null; then
    eval "$(mise activate bash)"
fi

# Starship
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi
