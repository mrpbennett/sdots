#!/usr/bin/env bash

# File system
if command -v eza &>/dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

# Fuzzy find (https://junegunn.github.io/fzf/)
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'
sff() {
  if [ $# -eq 0 ]; then
    echo "Usage: sff <destination> (e.g. sff host:/tmp/)"
    return 1
  fi
  local file
  file=$(find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff) && [ -n "$file" ] && scp "$file" "$1"
}

if command -v zoxide &>/dev/null; then
  alias cd="z"
  zd() {
    if (($# == 0)); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      if ! z "$@"; then
        echo "Error: Directory not found"
        return 1
      fi

      printf "\U000F17A9 "
      pwd
    fi
  }
fi

# DIRS ---
alias af="alias"
alias afs="alias | rg"

alias -g H='| head'
alias -g L='| less'
alias -g C='| cat'
alias -g G='| rg'
alias -g AS='| awk "NR>1"'
alias -g TS='| tspin | spacer'
alias -g NUL="2>&1 >/dev/null"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# TOOLS ---
alias e="exit"  # a swifter exit
alias v="nvim"  # quicker nvim
alias bt="btop" # better activity monitor
alias t='tmux attach || tmux new -s Session'
alias h="herdr"
alias cat="bat" # a better cat
alias d="docker"
alias lzg='lazygit'
alias lzd='lazydocker'

source <(kubectl completion zsh)
zstyle ':completion:*' menu select # arrow keys / repeated Tab to pick from the list

alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="k get"
alias kl="k logs -f"
alias kgp="k get pod"
alias ke="k exec -it"

alias kctx='kubectx'
alias kns="kubens"

alias sof="sofka"

# ARGOCD ---
alias arg="argocd"
alias argl="arg list"
alias arga="arg app"
alias argli="arg login argocd.70ld.dev --grpc-web"

# HELM ---
alias hrl="helm repo list"
alias hru="helm repo update"
alias hsr="helm search repo ''"
hsv() {
  helm show values "$@" | bat -l yaml
}

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
