#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
target_home="${HOME}"
mode="dry-run"
install_packages="false"

stow_packages=(
  atuin
  wezterm
  git
  herdr
  mise
  nvim
  starship
  tmux
  zsh
)

usage() {
  cat <<'USAGE'
Usage: ./install.sh [options]

Safely preview or apply myagenterminal.

Options:
  --apply          Create symlinks. Without this flag, only simulate changes.
  --packages       Check packages in dry-run mode, or install them with --apply.
  --target DIR     Use DIR as the target home (useful for testing).
  -h, --help       Show this help.

Examples:
  ./install.sh
  ./install.sh --apply
  ./install.sh --apply --packages
USAGE
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

while (( $# > 0 )); do
  case "$1" in
    --apply)
      mode="apply"
      ;;
    --packages)
      install_packages="true"
      ;;
    --target)
      shift
      (( $# > 0 )) || die "--target requires a directory"
      target_home="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
  shift
done

[[ -d "${target_home}" ]] || die "target directory does not exist: ${target_home}"

manage_packages() {
  [[ "${install_packages}" == "true" ]] || return 0
  command -v brew >/dev/null 2>&1 || die "Homebrew is required for --packages"

  if [[ "${mode}" == "apply" ]]; then
    printf 'Installing packages declared in %s\n' "${repo_dir}/Brewfile"
    brew bundle --no-upgrade --file "${repo_dir}/Brewfile"
    return
  fi

  if brew bundle check --file "${repo_dir}/Brewfile"; then
    printf 'All Brewfile dependencies are already installed.\n'
  else
    printf 'Dry-run only: Brewfile dependencies are missing; nothing was installed.\n'
  fi
}

stow_configs() {
  command -v stow >/dev/null 2>&1 || die "GNU Stow is required (brew install stow)"

  local -a stow_args=(
    --dir "${repo_dir}"
    --target "${target_home}"
    --restow
    --verbose=1
  )

  if [[ "${mode}" == "dry-run" ]]; then
    stow_args+=(--simulate)
    printf 'Dry-run: checking Stow links under %s\n' "${target_home}"
  else
    printf 'Applying Stow links under %s\n' "${target_home}"
  fi

  stow "${stow_args[@]}" "${stow_packages[@]}"
}

manage_packages
stow_configs

if [[ "${mode}" == "dry-run" ]]; then
  printf '\nNo changes were made. Re-run with --apply after reviewing the output.\n'
else
  printf '\nmyagenterminal links applied successfully. Open a new shell to load them.\n'
fi
