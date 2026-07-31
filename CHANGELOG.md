# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.1.5] - 2026-07-31

### Added

- More tooling via mise: glow, tlrc, yq, xh
- Automatic security upgrades (unattended-upgrades) in `install.sh`

### Changed

- `buf` replaced by `duf`
- Yazi keymap is now `<leader>y` instead of `<leader> `
- Refactored apt package installation in `install.sh`

## [v0.1.2] - 2026-07-31

### Added

- Yazi flavours (catppuccin latte & macchiato)
- Yazi theme config and Neovim integration

## [v0.1.1] - 2026-07-31

### Added

- gh CLI config and switched git protocol to SSH
- Language support for LazyVim (incl. Rust)
- Better Tailscale support in `install.sh`
- Mascot image to README
- Lualine config for Neovim

### Changed

- Reworked tmux config: improved bindings, ctrl+space prefix
- Cleaned up Atuin config with daemon settings
- Sorted shell configuration, removed `inputrc.sh`
- `install.sh` runs gum before task selection
- README updates

### Fixed

- tmux bindings (issue #8)
- removing `inputrc.sh` and it's symlink. No longer needed as we're using zsh

## [v0.1.0] - 2026-07-28

Initial tagged release.
