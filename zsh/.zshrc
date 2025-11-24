###############################################
#        Powerlevel10k Instant Prompt
###############################################
# Keep this at the very top for performance
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


###############################################
#                 Oh-My-Zsh
###############################################

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# Using your minimal Vercel P10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

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
  bgnotify
)

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


###############################################
#                Powerlevel10k
###############################################

# Your theme config file
if [[ -f "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
fi


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
