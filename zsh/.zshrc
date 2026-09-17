# Keep interactive-only setup out of scripts and non-interactive shells.
[[ -o interactive ]] || return

export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-FRX"

setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

brew_prefix=""
if command -v brew >/dev/null 2>&1; then
  brew_prefix="$(brew --prefix)"
  [[ -d "${brew_prefix}/share/zsh-completions" ]] && \
    fpath=("${brew_prefix}/share/zsh-completions" $fpath)
fi

autoload -Uz compinit
compinit

if [[ -n "${brew_prefix}" ]]; then
  [[ -r "${brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "${brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

alias t="tmux"
alias h="herdr"
alias v="nvim"
alias cat="bat"
alias ls="eza --group-directories-first"
alias ll="eza --long --all --group --git --group-directories-first"
alias tree="eza --tree --group-directories-first"

# zsh-syntax-highlighting must be sourced after other interactive integrations.
if [[ -n "${brew_prefix}" && \
      -r "${brew_prefix}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${brew_prefix}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
unset brew_prefix

# Keep publisher-native agent CLIs ahead of mise shims and other installs.
export PATH="${HOME}/.local/bin:${PATH}"
