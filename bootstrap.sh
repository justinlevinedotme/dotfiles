#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         macOS Bootstrap Script - Dotfiles Setup           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "🔐 Requesting sudo and keeping it fresh..."
sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT
echo "✓ Sudo keep-alive started"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 1: System Prerequisites"
echo "═══════════════════════════════════════════════════════════"
echo ""

echo "→ Installing Xcode CLI Tools (if needed)..."
xcode-select --install 2>/dev/null || echo "✓ Xcode CLI Tools already installed"

echo "→ Installing Rosetta 2 (Apple Silicon)..."
softwareupdate --install-rosetta --agree-to-license 2>/dev/null || echo "✓ Rosetta 2 already installed or not needed"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 2: Homebrew Setup"
echo "═══════════════════════════════════════════════════════════"
echo ""

if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "✓ Homebrew installed"
else
  echo "✓ Homebrew already installed"
fi

echo "→ Updating Homebrew..."
brew update
brew doctor || echo "⚠️  Homebrew doctor found issues (non-critical)"

echo "→ Tapping homebrew/cask-fonts..."
brew tap homebrew/cask-fonts 2>/dev/null || echo "✓ Already tapped"

if [[ -d "/opt/homebrew/bin" ]]; then
  echo "→ Adding Homebrew to shell environment..."
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "✓ Homebrew added to PATH"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 3: Installing GUI Applications"
echo "═══════════════════════════════════════════════════════════"
echo ""

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
  rectangle
  onyx
  screen-studio
  setapp
  discord
  rightfont
  docker
  font-geist-mono-nerd-font
  font-geist
)

echo "📦 Installing ${#casks[@]} GUI applications and fonts..."
echo ""

for app in "${casks[@]}"; do
  if brew list --cask "$app" &>/dev/null; then
    echo "✓ $app (already installed)"
  else
    echo "→ Installing $app..."
    brew install --cask "$app" 2>/dev/null && echo "  ✓ Installed" || echo "  ⚠️  Failed"
  fi
done
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 4: Installing CLI Tools"
echo "═══════════════════════════════════════════════════════════"
echo ""

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
  dockutil
  btop
  tldr
  bat
  ffmpeg
  mas
)

echo "📦 Installing ${#formulae[@]} command-line tools..."
echo ""

for formula in "${formulae[@]}"; do
  if brew list "$formula" &>/dev/null; then
    echo "✓ $formula (already installed)"
  else
    echo "→ Installing $formula..."
    brew install "$formula" 2>/dev/null && echo "  ✓ Installed" || echo "  ⚠️  Failed"
  fi
done
echo ""

echo "→ Setting up fzf shell keybindings..."
if command -v fzf >/dev/null 2>&1; then
  "$(brew --prefix)"/opt/fzf/install --all --no-bash --no-fish
  echo "✓ fzf configured for Zsh"
else
  echo "⚠️  fzf not found"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 5: Git & GitHub Configuration"
echo "═══════════════════════════════════════════════════════════"
echo ""

echo "→ Git version: $(git --version)"

if [[ -n "$GIT_NAME" && -z "$(git config --global user.name)" ]]; then
  git config --global user.name "$GIT_NAME"
  echo "✓ Git user.name set to: $GIT_NAME"
elif [[ -n "$(git config --global user.name)" ]]; then
  echo "✓ Git user.name already set: $(git config --global user.name)"
else
  echo "⚠️  GIT_NAME not set and no existing git user.name"
fi

if [[ -n "$GIT_EMAIL" && -z "$(git config --global user.email)" ]]; then
  git config --global user.email "$GIT_EMAIL"
  echo "✓ Git user.email set to: $GIT_EMAIL"
elif [[ -n "$(git config --global user.email)" ]]; then
  echo "✓ Git user.email already set: $(git config --global user.email)"
else
  echo "⚠️  GIT_EMAIL not set and no existing git user.email"
fi

echo "→ Setting default branch to 'main'..."
git config --global init.defaultBranch "main" 2>/dev/null || true
echo "✓ Default branch set"

if command -v gh &>/dev/null; then
  if gh auth status &>/dev/null; then
    echo "✓ GitHub CLI already authenticated"
  else
    echo "🔑 Logging into GitHub CLI (browser)..."
    gh auth login --git-protocol https --hostname github.com --web || echo "⚠️  GitHub login failed or skipped"
  fi
else
  echo "⚠️  GitHub CLI not installed; skipping gh auth"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 6: Security Configuration"
echo "═══════════════════════════════════════════════════════════"
echo ""

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
    echo "✓ Touch ID already enabled for sudo"
  elif ! head -n1 "$PAM_FILE" | grep -q "$FIRST_LINE"; then
    echo "⚠️  $PAM_FILE not in expected format; skipping Touch ID"
  else
    sudo sed -i .bak -e "s/$FIRST_LINE/$FIRST_LINE\\nauth       sufficient     pam_tid.so/" "$PAM_FILE"
    sudo rm "$PAM_FILE.bak" 2>/dev/null || true
    echo "✓ Touch ID enabled for sudo"
  fi
else
  echo "⚠️  Touch ID module not found; skipping"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 7: macOS System Configuration"
echo "═══════════════════════════════════════════════════════════"
echo ""

if [ -d "$DOTFILES_DIR/macos" ]; then
  echo "→ Found macOS configuration scripts"
  for script in "$DOTFILES_DIR"/macos/*.sh; do
    if [ ! -x "$script" ]; then
      echo "⚠️  ${script##*/} is not executable, skipping..."
      continue
    fi
    echo ""
    echo "Running ${script##*/}..."
    "$script" || echo "⚠️  ${script##*/} failed"
  done
else
  echo "⚠️  No macOS scripts directory found at $DOTFILES_DIR/macos"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 8: Default Applications"
echo "═══════════════════════════════════════════════════════════"
echo ""

echo "→ Setting Helium Browser as default browser..."
if [ -d "/Applications/Helium Browser.app" ]; then
  open -a "Helium Browser" --args --make-default-browser 2>/dev/null || echo "⚠️  Failed to set default browser"
  echo "✓ Helium Browser set as default"
else
  echo "⚠️  Helium Browser not found"
fi

echo "→ Setting up Ghostty terminal..."
if [ -d "/Applications/Ghostty.app" ]; then
  sudo ln -sf /Applications/Ghostty.app/Contents/MacOS/ghostty /usr/local/bin/ghostty 2>/dev/null || true
  echo "✓ Ghostty symlinked to /usr/local/bin/ghostty"
else
  echo "⚠️  Ghostty not found"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 9: Node.js & Package Managers"
echo "═══════════════════════════════════════════════════════════"
echo ""

echo "📦 Setting up Node Version Manager (nvm)..."
mkdir -p ~/.nvm

# Note: nvm configuration should already be in zsh/.zshrc (managed by Stow)
if grep -q 'NVM_DIR' "$DOTFILES_DIR/zsh/.zshrc" 2>/dev/null; then
  echo "✓ nvm configuration found in dotfiles zsh/.zshrc"
else
  echo "⚠️  nvm not configured in dotfiles - you may need to add it manually"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"

if command -v nvm &>/dev/null; then
  echo "→ Installing Node.js LTS..."
  nvm install --lts
  nvm alias default lts/*
  echo "✓ Node.js LTS installed: $(node --version)"

  if ! command -v pnpm &>/dev/null; then
    echo "→ Installing pnpm..."
    npm install -g pnpm
    echo "✓ pnpm installed: $(pnpm --version)"
  else
    echo "✓ pnpm already installed: $(pnpm --version)"
  fi
else
  echo "⚠️  nvm not available in PATH; skipping Node install"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 10: Rust Toolchain"
echo "═══════════════════════════════════════════════════════════"
echo ""

echo "🦀 Setting up Rust..."
if ! command -v rustup &>/dev/null; then
  echo "→ Installing rustup..."
  brew install rustup-init
  rustup-init -y --profile minimal --default-toolchain stable --no-modify-path
  echo "✓ Rust installed"
else
  echo "✓ rustup already installed"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 11: Dotfiles Installation"
echo "═══════════════════════════════════════════════════════════"
echo ""

if [ ! -d "$DOTFILES_DIR/.git" ]; then
  DOTFILES_REPO="${DOTFILES_REPO:-}"
  if [ -z "$DOTFILES_REPO" ] && [ -n "$GITHUB_USER" ]; then
    DOTFILES_REPO="https://github.com/$GITHUB_USER/.dotfiles"
  fi

  if [ -n "$DOTFILES_REPO" ]; then
    echo "→ Cloning dotfiles from $DOTFILES_REPO into $DOTFILES_DIR..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || echo "⚠️  Failed to clone dotfiles"
  else
    echo "⚠️  DOTFILES_REPO not set and no repo inferred; skipping clone"
  fi
else
  echo "✓ Dotfiles repo found at $DOTFILES_DIR"
fi

if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  if [ -d .git ]; then
    echo "→ Updating dotfiles repo..."
    git pull --ff-only || echo "⚠️  Git pull failed"
  fi

  echo "→ Using Stow to symlink configs..."
  STOW_PACKAGES=(zsh git eza fastfetch ghostty starship zed vscode raycast)

  for package in "${STOW_PACKAGES[@]}"; do
    if [ -d "$package" ]; then
      echo "  → Stowing $package..."
      stow -R "$package" 2>/dev/null && echo "    ✓ $package" || echo "    ⚠️  $package failed (may need --adopt)"
    else
      echo "    ⚠️  $package directory not found"
    fi
  done

  echo "✓ Stow configuration complete"
else
  echo "⚠️  Dotfiles directory not found at $DOTFILES_DIR"
fi
echo ""

echo "═══════════════════════════════════════════════════════════"
echo "  STEP 12: Shell Configuration"
echo "═══════════════════════════════════════════════════════════"
echo ""

if command -v zsh >/dev/null 2>&1; then
  CURRENT_SHELL="$(dscl . -read /Users/$USER UserShell 2>/dev/null | awk '{print $2}')"
  DESIRED_SHELL="$(command -v zsh)"
  if [[ "$CURRENT_SHELL" != "$DESIRED_SHELL" ]]; then
    echo "→ Setting default shell to $DESIRED_SHELL..."
    chsh -s "$DESIRED_SHELL"
    echo "✓ Default shell changed to Zsh"
  else
    echo "✓ Default shell already set to Zsh"
  fi
else
  echo "⚠️  zsh not found; skipping chsh"
fi
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  ✅ Bootstrap Complete!                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "→ Please restart your terminal to apply all changes."
echo ""
