


###############################################
#                 Oh-My-Zsh
###############################################

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"


export DOCKER_SOCK="/Users/jstn/.docker/run/docker.sock"
docker() {
  command docker "$@" 2>/dev/null
}

plugins=(
  git
  history
  common-aliases
  zsh-autosuggestions
  zsh-syntax-highlighting
  vscode
  brew
  macos
  node
  npm
  yarn
  rust
  docker
  docker
  bgnotify
  zoxide
)
export ZOXIDE_CMD_OVERRIDE=cd
source $ZSH/oh-my-zsh.sh


###############################################
#            Load Modular Dotfiles
###############################################

# Exports (PATH, Homebrew, nvm, pnpm, Rust, Python, etc.)
if [[ -f "$HOME/.dotfiles/zsh/exports.zsh" ]]; then
  source "$HOME/.dotfiles/zsh/exports.zsh"
fi

# Aliases (git, node, fmml, docker, nav shortcuts, etc.)
if [[ -f "$HOME/.dotfiles/zsh/aliases.zsh" ]]; then
  source "$HOME/.dotfiles/zsh/aliases.zsh"
fi

# Functions (optional)
if [[ -f "$HOME/.dotfiles/zsh/functions.zsh" ]]; then
  source "$HOME/.dotfiles/zsh/functions.zsh"
fi


###############################################
#               Completion System
###############################################

autoload -U compinit
compinit


###############################################
#               Shell Behavior / History
###############################################

HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"

setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS


# Oh My Posh init
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.json)"
###############################################
#        Local Overrides (Not in Git)
###############################################
# Contains:
# - API keys
# - tokens
# - per-machine paths
# - anything private or host-specific
###############################################

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
