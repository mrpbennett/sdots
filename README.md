<p align="center">
    <img alt="GNU Stow" src="https://img.shields.io/badge/managed_with-GNU_Stow-4CAF50?style=flat-square&logo=gnu&logoColor=white"/>
    <img alt="Ubuntu" src="https://img.shields.io/badge/platform-ubuntu-000000?style=flat-square&logo=ubuntu&logoColor=white"/>
    <img alt="zsh shell" src="https://img.shields.io/badge/shell-zsh-4FC3F7?style=flat-square"/>
    <img alt="LazyVim" src="https://img.shields.io/badge/editor-LazyVim-7C3AED?style=flat-square"/>
</p>

A terminal setup for Ubuntu inspired by [Omaterm](https://github.com/omacom-io/omaterm) and [Omarchy](https://omarchy.org/).

## What it sets up

One command, three delivery channels — **apt** for the OS layer, **mise** for the version-pinned toolbelt, and a little **glue** (Tailscale, SSH key, Oh My Zsh, TPM, gum) for what package managers won't do. Unpacked, it looks like this:

```
┌──────────────────────────────────────────────────────────────┐
│  TERMINAL     zsh + oh-my-zsh · starship · tmux · fzf        │
│  TERMINAL     zoxide · atuin · sesh                          │
│  FILES        eza · bat · fd · ripgrep · yazi                │
│  SYSTEM       btop · duf · glow · tlrc · jq · yq · xh        │
│  GIT          lazygit · gh · hunk · worktrunk                │
│  DOCKER       docker · compose · lazydocker                  │
│  AGENTS       opencode · claude-code                         │
│  EDITOR       neovim · lazyvim                               │
│  RUNTIMES     node (lts) · python · go · rust                │
└──────────────────────────────────────────────────────────────┘
```

Everything in the box is declared in `~/.config/mise/config.toml` and kept current with a single `mise upgrade`; the apt layer runs on `unattended-upgrades` so security patches land by themselves. Worth knowing before you click around: `hunk` stages line-level git changes, `worktrunk` spins up git worktrees for parallel agents, `sesh` is the tmux session picker behind `prefix + T`, and `duf`/`btop`/`tlrc`/`glow` are the pretty versions of `df`, `top`, `man`, and markdown-`cat`.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/mrpbennett/sdots/main/install.sh | bash
```

Log out and back in after installation before using Docker without `sudo`.

## Stow maintenance

All symlinks are managed with `--no-folding` so stow creates real directories and only symlinks individual files. This prevents conflicts when multiple tools share a parent like `~/.config/`.

| Command                                                                 | Purpose                                                             |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `stow --no-folding --restow --dir "$DOTFILES_DIR" --target "$HOME" .`   | Relink everything (safe to re-run after adding/removing files)      |
| `stow --no-folding --simulate --dir "$DOTFILES_DIR" --target "$HOME" .` | Dry run — preview what would change without touching the filesystem |
| `stow --delete --dir "$DOTFILES_DIR" --target "$HOME" .`                | Remove all managed symlinks (leaves real files untouched)           |

`$DOTFILES_DIR` is wherever you cloned the repo — typically `~/.local/share/sdots`.

## Tmux keybindings

<summary>All custom keybindings — prefix is <code>Ctrl+Space</code> or <code>Ctrl+s</code></summary>

### Config

| Key          | Action                       |
| ------------ | ---------------------------- |
| `prefix + q` | Reload config                |
| `prefix + ?` | Show all keybindings (popup) |

### Pane splits

| Key                   | Action                        |
| --------------------- | ----------------------------- |
| `prefix + \|`         | Split right                   |
| `prefix + -`          | Split down                    |
| `prefix + h`          | Split right (vim-style)       |
| `prefix + v`          | Split down (vim-style)        |
| `prefix + x`          | Kill pane                     |
| `prefix + f`          | Floating shell popup (80×60%) |
| `Alt + Enter`         | Split right (no prefix)       |
| `Alt + Shift + Enter` | Split down (no prefix)        |
| `Alt + Escape`        | Kill pane (no prefix)         |

### Pane navigation

| Key                    | Action                          |
| ---------------------- | ------------------------------- |
| `prefix + h/j/k/l`     | Navigate panes (vim-style)      |
| `Ctrl + Alt + ←/→/↑/↓` | Navigate panes (arrows)         |
| `Ctrl + Alt + h/j/k/l` | Navigate panes (vim, no prefix) |

### Pane resize

| Key                            | Action                          |
| ------------------------------ | ------------------------------- |
| `prefix + H/J/K/L`             | Resize pane 5 cells             |
| `Ctrl + Alt + Shift + ←/→/↑/↓` | Resize pane 5 cells (no prefix) |

### Windows

| Key          | Action        |
| ------------ | ------------- |
| `prefix + c` | New window    |
| `prefix + r` | Rename window |
| `prefix + k` | Kill window   |

### Window navigation

| Key               | Action                        |
| ----------------- | ----------------------------- |
| `Alt + 1–9`       | Switch to window (no prefix)  |
| `Alt + ←`         | Previous window (no prefix)   |
| `Alt + →`         | Next window (no prefix)       |
| `Alt + Shift + ←` | Move window left (no prefix)  |
| `Alt + Shift + →` | Move window right (no prefix) |

### Sessions

| Key          | Action                          |
| ------------ | ------------------------------- |
| `prefix + C` | New session                     |
| `prefix + R` | Rename session                  |
| `prefix + K` | Kill session                    |
| `prefix + P` | Previous session                |
| `prefix + N` | Next session                    |
| `prefix + T` | Sesh session picker (fzf popup) |

### Copy mode (vi)

| Key          | Action                  |
| ------------ | ----------------------- |
| `prefix + [` | Enter copy mode         |
| `v`          | Begin selection         |
| `y`          | Copy selection and exit |
