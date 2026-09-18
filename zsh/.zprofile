# Initialize Homebrew for both Apple Silicon and Intel Macs.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Preserve local integrations when they exist on this Mac.
if [[ -r "${HOME}/.orbstack/shell/init.zsh" ]]; then
  source "${HOME}/.orbstack/shell/init.zsh"
fi

if [[ -d "/Applications/Obsidian.app/Contents/MacOS" ]]; then
  export PATH="${PATH}:/Applications/Obsidian.app/Contents/MacOS"
fi

# Publisher-native developer CLIs install their launchers here.
# Keep this last so local integrations cannot shadow them in PATH.
export PATH="${HOME}/.local/bin:${PATH}"
