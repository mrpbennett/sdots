#!/usr/bin/env bash
set -euo pipefail

# LXCs may run as root without sudo; VMs generally use an unprivileged user.
as_root=(sudo)
if [[ $(id -u) -eq 0 ]]; then
  as_root=()
fi

"${as_root[@]}" apt-get update
"${as_root[@]}" env DEBIAN_FRONTEND=noninteractive apt-get install -y curl git zsh

# A downloaded script has no adjacent files; fetch only the two LXC configs.
if [[ -f ${BASH_SOURCE[0]:-} ]] &&
  [[ -f $(dirname -- "${BASH_SOURCE[0]}")/.zshrc ]] &&
  [[ -f $(dirname -- "${BASH_SOURCE[0]}")/mise/config.toml ]]; then
  config_dir=$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")
else
  config_dir=$(mktemp -d)
  trap 'rm -rf -- "$config_dir"' EXIT
  curl -fsSL https://raw.githubusercontent.com/mrpbennett/sdots/main/install/lxc/.zshrc -o "$config_dir/.zshrc"
  mkdir -p "$config_dir/mise"
  curl -fsSL https://raw.githubusercontent.com/mrpbennett/sdots/main/install/lxc/mise/config.toml -o "$config_dir/mise/config.toml"
  curl -fsSL https://raw.githubusercontent.com/mrpbennett/sdots/main/install/lxc/starship.toml -o "$config_dir/starship.toml"
fi

mkdir -p "$HOME/.config/mise"
# Copy, rather than link, and keep numbered backups when replacing user files.
for file in .zshrc .config/mise/config.toml; do
  source_file="$config_dir/${file#.config/}"
  target_file="$HOME/$file"
  if [[ -L $target_file ]] || ! cmp -s "$source_file" "$target_file"; then
    cp --backup=numbered --remove-destination -- "$source_file" "$target_file"
  fi
done

MISE_BIN=$(command -v mise || true)
if [[ -z $MISE_BIN ]]; then
  curl -fsSL https://mise.run | sh
  MISE_BIN="$HOME/.local/bin/mise"
fi

"$MISE_BIN" trust -y "$HOME/.config/mise/config.toml"
"$MISE_BIN" install -y
"${as_root[@]}" chsh -s "$(command -v zsh)" "$(id -un)"
