#!/usr/bin/env bash
set -e

echo "Requesting sudo and keeping it fresh..."
sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT

echo "Installing Xcode CLI Tools (if needed)..."
xcode-select --install 2>/dev/null || true

echo "Installing Rosetta 2..."
softwareupdate --install-rosetta --agree-to-license || true

if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "→ Updating Homebrew..."
brew update
brew doctor || true

if [[ -d "/opt/homebrew/bin" ]]; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "📦 Installing GUI apps via Homebrew..."
casks=(
  folx
  keka
  bambu-studio
  dropbox
  helium-browser
  ghostty
  zed
  visual-studio-code
  hiddenbar
  raindropio
  proton-pass
  raycast
  onyx
  screen-studio
  setapp
  discord
)

for app in "${casks[@]}"; do
  echo "→ Installing $app..."
  brew install --cask "$app"
done

echo "📦 Installing formulae via Homebrew..."
formulae=(
  git
  stow
  nvm
  eza
  fastfetch
  zoxide
  fzf
  starship
  wget
  gh
  curl
  tree
)

for formula in "${formulae[@]}"; do
  echo "→ Installing $formula..."
  brew install "$formula"
done

# fzf shell keybindings/completions (no bash/fish)
if command -v fzf >/dev/null 2>&1; then
  "$(brew --prefix)"/opt/fzf/install --all --no-bash --no-fish
fi

echo "→ Git version:"
git --version
echo ""

# -----------------------------------------------------
# GIT SETUP & GH LOGIN
# -----------------------------------------------------
# Set git identity if provided via env and not already set.
if [[ -n "$GIT_NAME" && -z "$(git config --global user.name)" ]]; then
  git config --global user.name "$GIT_NAME"
fi
if [[ -n "$GIT_EMAIL" && -z "$(git config --global user.email)" ]]; then
  git config --global user.email "$GIT_EMAIL"
fi
git config --global init.defaultBranch "main" 2>/dev/null || true

if command -v gh &>/dev/null; then
  if ! gh auth status &>/dev/null; then
    echo "🔑 Logging into GitHub CLI (browser)..."
    gh auth login --git-protocol https --hostname github.com --web || true
  fi
else
  echo "ℹ️ GitHub CLI not installed; skipping gh auth"
fi

# -----------------------------------------------------
# TOUCH ID FOR SUDO (if available)
# -----------------------------------------------------
echo "🔒 Enabling Touch ID for sudo (if available)..."
if ls /usr/lib/pam | grep -q "pam_tid.so" 2>/dev/null; then
  if [[ -f /etc/pam.d/sudo_local || -f /etc/pam.d/sudo_local.template ]]; then
    PAM_FILE="/etc/pam.d/sudo_local"
    FIRST_LINE="# sudo_local: local config file which survives system update and is included for sudo"
    if [[ ! -f "$PAM_FILE" ]]; then
      echo "$FIRST_LINE" | sudo tee "$PAM_FILE" >/dev/null
    fi
  else
    PAM_FILE="/etc/pam.d/sudo"
    FIRST_LINE="# sudo: auth account password session"
  fi

  if grep -q pam_tid.so "$PAM_FILE"; then
    echo "→ Touch ID already enabled for sudo"
  elif ! head -n1 "$PAM_FILE" | grep -q "$FIRST_LINE"; then
    echo "⚠️ $PAM_FILE not in expected format; skipping Touch ID"
  else
    sudo sed -i .bak -e "s/$FIRST_LINE/$FIRST_LINE\\nauth       sufficient     pam_tid.so/" "$PAM_FILE"
    sudo rm "$PAM_FILE.bak" 2>/dev/null || true
    echo "→ Touch ID enabled for sudo"
  fi
else
  echo "→ Touch ID module not found; skipping"
fi

# -----------------------------------------------------
# MACOS POST-INSTALL SCRIPTS
# -----------------------------------------------------
echo ""
echo "🖥️ Applying macOS preferences (dock, etc.)..."
if [ -d "$DOTFILES_DIR/macos" ]; then
  for script in "$DOTFILES_DIR"/macos/*.sh; do
    [ -x "$script" ] || continue
    echo "→ Running ${script##*/}"
    "$script" || echo "⚠️ ${script##*/} failed"
  done
else
  echo "→ No macOS scripts directory found"
fi


# -----------------------------------------------------
# DEFAULT APPS
# -----------------------------------------------------
echo ""
echo "⚙️ Setting default apps..."

# Default browser → Helium
echo "→ Setting Helium Browser as default..."
open -a "Helium Browser" --args --make-default-browser 2>/dev/null || true

# Default terminal → Ghostty (best effort)
echo "→ Setting Ghostty as default terminal (VSCode + system helpers)..."
if [ -d "/Applications/Ghostty.app" ]; then
  sudo ln -sf /Applications/Ghostty.app/Contents/MacOS/ghostty /usr/local/bin/ghostty 2>/dev/null || true
fi


# -----------------------------------------------------
# NODE VERSION MANAGER (NVM)
# -----------------------------------------------------
echo ""
echo "📦 Installing Node Version Manager (nvm)..."
mkdir -p ~/.nvm

if ! grep -q 'NVM_DIR' ~/.zshrc; then
  cat <<'EOF' >> ~/.zshrc

# NVM
export NVM_DIR="$HOME/.nvm"
source "$(brew --prefix nvm)/nvm.sh"

EOF
fi

# Activate nvm in this session and install Node + pnpm
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"
if command -v nvm &>/dev/null; then
  nvm install --lts
  nvm alias default lts/*
  if ! command -v pnpm &>/dev/null; then
    npm install -g pnpm
  fi
else
  echo "⚠️ nvm not available in PATH; skipping Node install"
fi


# -----------------------------------------------------
# RUST TOOLCHAIN
# -----------------------------------------------------
echo ""
echo "🦀 Installing Rust (minimal profile)..."
if ! command -v rustup &>/dev/null; then
  brew install rustup-init
  rustup-init -y --profile minimal --default-toolchain stable --no-modify-path
else
  echo "→ rustup already installed; skipping"
fi

echo ""
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

echo "🚀 Linking Raycast scripts... (handled by Dotbot install)"

# -----------------------------------------------------
# DOTFILES (CLONE/UPDATE + DOTBOT INSTALL)
# -----------------------------------------------------
echo ""
echo "📁 Applying dotfiles with Dotbot..."

# Clone dotfiles into ~ if missing.
if [ ! -d "$DOTFILES_DIR/.git" ]; then
  DOTFILES_REPO="${DOTFILES_REPO:-}"
  if [ -z "$DOTFILES_REPO" ] && [ -n "$GITHUB_USER" ]; then
    DOTFILES_REPO="https://github.com/$GITHUB_USER/.dotfiles"
  fi

  if [ -n "$DOTFILES_REPO" ]; then
    echo "→ Cloning dotfiles from $DOTFILES_REPO into $DOTFILES_DIR ..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || echo "⚠️ Failed to clone dotfiles"
  else
    echo "⚠️ DOTFILES_REPO not set and no repo inferred; skipping clone"
  fi
fi

if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  if [ -d .git ]; then
    git pull --ff-only || true
    git submodule update --init --recursive || true
  fi

  if [ -x ./install ]; then
    ./install || echo "⚠️ Dotbot install failed"
  else
    echo "⚠️ Dotbot install script not found"
  fi
else
  echo "⚠️ Dotfiles directory not found at $DOTFILES_DIR"
fi

echo ""
echo "✅ Bootstrap complete!"
echo "→ Please restart your terminal to apply all changes."

# -----------------------------------------------------
# SET DEFAULT SHELL TO ZSH
# -----------------------------------------------------
if command -v zsh >/dev/null 2>&1; then
  CURRENT_SHELL="$(dscl . -read /Users/$USER UserShell 2>/dev/null | awk '{print $2}')"
  DESIRED_SHELL="$(command -v zsh)"
  if [[ "$CURRENT_SHELL" != "$DESIRED_SHELL" ]]; then
    echo "→ Setting default shell to $DESIRED_SHELL"
    chsh -s "$DESIRED_SHELL"
  else
    echo "→ Default shell already set to zsh"
  fi
else
  echo "⚠️ zsh not found; skipping chsh"
fi
