#!/usr/bin/env bash
set -euo pipefail

target="${1:-}"
if [[ -z $target ]]; then
  if ! (: </dev/tty) 2>/dev/null; then
    echo "Usage: bash install.sh {vm|lxc} (or curl ... | bash -s -- vm|lxc)" >&2
    exit 1
  fi
  read -r -p "Install for a (v)M or (l)XC? " target </dev/tty
fi

case "$target" in
vm | v) script=install/vm.sh ;;
lxc | l) script=install/lxc/install.sh ;;
*)
  echo "Choose vm or lxc." >&2
  exit 1
  ;;
esac

# Use the local scripts in a checkout; stdin (curl | bash) has no script path.
if [[ -f ${BASH_SOURCE[0]:-} ]]; then
  repo_dir=$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")
  if [[ -f "$repo_dir/$script" ]]; then
    exec bash "$repo_dir/$script"
  fi
fi

curl -fsSL "https://raw.githubusercontent.com/mrpbennett/sdots/main/$script" | bash
