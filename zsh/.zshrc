export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export TERM=xterm-256color
export DOCKER_SOCK="/Users/jstn/.docker/run/docker.sock"
export HOMEBREW_NO_ENV_HINTS=1
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
  starship
  node
  npm
  yarn
  rust
  docker
  docker
  bgnotify
  zoxide
  eza
)
# eza colors tuned to Ghostty palette
#  - dirs = blue (palette 4)
#  - symlinks = cyan (palette 6)
#  - exec = green (palette 2)
#  - broken = red (palette 1)
export EZA_COLORS="di=34:ln=36:ex=32:or=31:mi=1;31:sn=33:bd=33:cd=33:pi=33:so=35"
export ZOXIDE_CMD_OVERRIDE=cd

source $ZSH/oh-my-zsh.sh
# Use eza if available
alias ls='eza --icons --group-directories-first --git -1'
alias ll='eza --icons --group-directories-first --git -l'
alias la='eza --icons --group-directories-first --git -la'
alias lt='eza --icons --group-directories-first --git --tree'



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

autoload -U compinit
compinit

HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"

setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

eval "$(starship init zsh)"

#local overrides
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

( fastfetch )
