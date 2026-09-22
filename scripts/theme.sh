#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  printf 'Usage: %s <day|night|status>\n' "$0" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
case "$1" in
  day|night|status) ;;
  *) usage ;;
esac

theme_file="${MYAGENTERMINAL_THEME_FILE:-${HOME}/.config/myagenterminal/theme}"
if [[ -L "$theme_file" || ( -e "$theme_file" && ! -f "$theme_file" ) ]]; then
  printf 'Refusing to replace a non-regular theme file: %s\n' "$theme_file" >&2
  exit 1
fi

if [[ "$1" == status ]]; then
  mode=night
  if [[ -f "$theme_file" ]]; then
    IFS= read -r mode < "$theme_file" || true
  fi
  if [[ "$mode" != day && "$mode" != night ]]; then
    printf 'Invalid saved theme mode in %s\n' "$theme_file" >&2
    exit 1
  fi
  printf 'Gruvbox %s (soft)\n' "$mode"
  exit 0
fi

mkdir -p -- "$(dirname -- "$theme_file")"
temporary_file="$(mktemp "${theme_file}.tmp.XXXXXX")"
trap 'rm -f -- "$temporary_file"' EXIT
printf '%s\n' "$1" > "$temporary_file"
mv -- "$temporary_file" "$theme_file"
trap - EXIT

# The active WezTerm config is watched even before the state file exists.
# Touching it makes the first switch reload reliably without changing Git content.
if [[ -z "${MYAGENTERMINAL_THEME_FILE:-}" ]]; then
  wezterm_config="${HOME}/.config/wezterm/wezterm.lua"
  if [[ -f "$wezterm_config" ]]; then
    touch -- "$wezterm_config"
  fi
  if command -v herdr >/dev/null 2>&1 &&
    herdr status server 2>/dev/null | grep -q '^status: running$'; then
    herdr server reload-config >/dev/null
  fi
fi

printf 'Gruvbox %s (soft) selected. Restart open Neovim sessions to apply it.\n' "$1"
