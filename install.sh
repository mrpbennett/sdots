#!/usr/bin/env bash
set -euo pipefail

# Directory where the dotfiles repo will (or already does) live.
# Also acts as fallback when the script is run outside a git checkout.
REPO_DIR="$HOME/.local/share/sdots"

cat <<'EOF'

________  ________  ________  _________  ________
|\   ____\|\   ___ \|\   __  \|\___   ___\\   ____\
\ \  \___|\ \  \_|\ \ \  \|\  \|___ \  \_\ \  \___|_
 \ \_____  \ \  \ \\ \ \  \\\  \   \ \  \ \ \_____  \
  \|____|\  \ \  \_\\ \ \  \\\  \   \ \  \ \|____|\  \
    ____\_\  \ \_______\ \_______\   \ \__\  ____\_\  \
   |\_________\|_______|\|_______|    \|__| |\_________\
   \|_________|                             \|_________|

EOF

# Resolve the dotfiles directory: prefer the repo beside this script, fall back
# to REPO_DIR, and clone from GitHub if neither exists yet.
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$REPO_DIR}")" 2>/dev/null && pwd || true)
if [[ ! -d $DOTFILES_DIR/.git ]]; then
  DOTFILES_DIR=$REPO_DIR
  [[ -d $DOTFILES_DIR/.git ]] || git clone --depth 1 https://github.com/mrpbennett/sdots.git "$DOTFILES_DIR"
fi

# Refresh package index before installing anything.
sudo apt-get update

echo "✓ Installing apt packages, including Docker & Nginx..."
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential curl git stow nginx zsh

# Install Docker from the distro package manager, then enable the daemon and
# add the current user to the docker group.
install_docker() {
  local target_user

  echo "Installing Docker..."

  if command -v docker &>/dev/null && systemctl cat docker.service &>/dev/null; then
    :
  elif [ -f /etc/arch-release ]; then
    sudo pacman -S --needed --noconfirm docker
  elif [ -f /etc/debian_version ]; then
    sudo apt-get update
    sudo apt-get install -y docker.io
  elif [ -f /etc/fedora-release ]; then
    sudo dnf install -y moby-engine
  else
    echo "Error: This OS is not supported by the installer."
    echo "Install Docker manually, then run this installer again."
    exit 1
  fi

  echo "Enabling Docker..."
  sudo systemctl enable --now docker.service
  sudo groupadd -f docker
  target_user="${SUDO_USER:-${USER:-$(id -un)}}"
  sudo usermod -aG docker "$target_user"

  echo
  echo "✓ Docker"
}

# Install mise (version manager), symlink config files with GNU Stow, then
# install all tools listed in ~/.config/mise/config.toml.
set_up_mise_and_stow() {

  echo "✓ Installing mise package manager..."
  MISE_BIN=$(command -v mise || true)
  if [[ -z $MISE_BIN ]]; then
    curl -fsSL https://mise.run | sh
    MISE_BIN="$HOME/.local/bin/mise"
  fi

  echo "✓ Running Stow for symlinks..."
  stow --no-folding --restow --dir "$DOTFILES_DIR" --target "$HOME" .
  ln -snf "$HOME/.config/shell/inputrc.sh" "$HOME/.inputrc"

  echo "✓ Installing packages via mise..."
  "$MISE_BIN" trust -y "$HOME/.config/mise/config.toml"
  "$MISE_BIN" install -y
  GOBIN="$HOME/.local/bin" "$MISE_BIN" exec -- go install github.com/joshmedeski/sesh/v2@latest
}

# Clone the Tmux Plugin Manager (TPM) and install its declared plugins.
install_tpm() {
  echo "✓ Installing TPM..."
  TPM_DIR="$HOME/.tmux/plugins/tpm"
  [[ -d $TPM_DIR ]] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
  "$MISE_BIN" exec -- "$TPM_DIR/bin/install_plugins"
}

# Install Charm's gum (TUI toolkit) from the distro package manager or
# third-party repo, depending on the platform.
install_gum() {
  command -v gum &>/dev/null && return

  echo "Installing gum..."

  if [ -f /etc/arch-release ]; then
    sudo pacman -S --needed --noconfirm gum
  elif [ -f /etc/debian_version ]; then
    # gum isn't in the Debian/Ubuntu repos; add Charm's apt repo first.
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" |
      sudo tee /etc/apt/sources.list.d/charm.list >/dev/null
    sudo apt-get update
    sudo apt-get install -y gum
  elif [ -f /etc/fedora-release ]; then
    sudo dnf install -y gum
  else
    echo "Error: This OS is not supported by the installer."
    echo "Install gum manually (https://github.com/charmbracelet/gum), then run this installer again."
    exit 1
  fi

  echo
  echo "✓ Gum"
}

# Appends a public SSH key to ~/.ssh/authorized_keys if not already present.
install_ssh_key() {
  local ssh_key="$1"

  [[ -n $ssh_key ]] || return 0

  mkdir -p "$HOME/.ssh" || return 1
  chmod 700 "$HOME/.ssh" || return 1
  touch "$HOME/.ssh/authorized_keys" || return 1
  chmod 600 "$HOME/.ssh/authorized_keys" || return 1

  if grep -qxF "$ssh_key" "$HOME/.ssh/authorized_keys"; then
    return
  else
    echo "$ssh_key" >>"$HOME/.ssh/authorized_keys" || return 1
  fi
}

# Prompt for an SSH public key (unless $KEY is set) and install it to
# authorized_keys for password-less login.
setup_ssh_public_key() {
  local ssh_key="$KEY"

  if [[ -z $ssh_key ]]; then
    gum_input_into ssh_key --placeholder "ssh-ed25519 AAAAC3..." --prompt "SSH key: " || return 1
  fi
  [[ -n $ssh_key ]] || {
    return
  }

  install_ssh_key "$ssh_key" || return 1

  echo "✓ SSH"
  echo
}

install_tailscale() {
  echo "✓ Installing TailScale..."
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo systemctl enable --now tailscaled
}

# Clone Oh My Zsh and its autosuggestions/syntax-highlighting plugins, then
# set zsh as the default shell for the current user.
install_oh_my_zsh() {

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  fi

  # Install oh-my-zsh plugins
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

  sudo chsh -s "$(which zsh)" "$(id -un)"
}

install_docker
set_up_mise_and_stow
install_tpm
install_gum
setup_ssh_public_key
install_tailscale
install_oh_my_zsh

echo "Done. Log out and back in before using Docker without sudo."
source ~/.zshrc
