###############################################
#                 PATH Setup
###############################################

# Ensure user-installed binaries take priority
export PATH="$HOME/bin:$PATH"

###############################################
#              Homebrew (Universal)
###############################################

# Apple Silicon
if [ -d /opt/homebrew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Intel fallback
if [ -d /usr/local/Homebrew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

###############################################
#                Node / pnpm / nvm
###############################################

# pnpm home
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# nvm setup
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

###############################################
#                      Rust
###############################################

export PATH="$HOME/.cargo/bin:$PATH"

###############################################
#                     Python
###############################################

# Python framework path
export PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:$PATH"

###############################################
#                 JavaScript Tools
###############################################

# Bun (optional)
[ -d "$HOME/.bun/bin" ] && export PATH="$HOME/.bun/bin:$PATH"

###############################################
#                  VSCode
###############################################

# Enable "code" CLI
if [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
fi

###############################################
#                   Golang (optional)
###############################################

if [ -d "$HOME/go/bin" ]; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi

###############################################
#               Shell Environment
###############################################

export EDITOR="nano"
export VISUAL="nano"
export PAGER="less"

###############################################
#             Local Secrets Override
###############################################
# ~/.zshrc.local should hold:
#   - API keys
#   - tokens
#   - custom machine-specific paths
#   (Do NOT commit ~/.zshrc.local to git)
###############################################

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
