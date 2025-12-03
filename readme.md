My dotfiles.

## Structure
- All configs live under `config/` (zsh, git, ghostty, zed, starship, eza, fastfetch, Raycast, macOS scripts).
- Raycast scripts are symlinked into `~/Documents/Raycast Scripts`.

## Installation from Scratch (Brand New Computer)

### Prerequisites
- macOS (Apple Silicon or Intel Mac)
- Internet connection
- Admin account with sudo privileges

### Quick Start

1. **Open Terminal** (Applications → Utilities → Terminal)

2. **Clone this repository:**
   ```bash
   git clone https://github.com/justinlevinedotme/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```
   > Note: Xcode Command Line Tools will be installed automatically if needed. If prompted, follow the on-screen instructions.

3. **Run the bootstrap script:**
   ```bash
   ./boostrap.sh
   ```

4. **Restart your terminal** when complete.

### One-Liner Install

For a completely fresh Mac where git isn't installed yet, you can use curl to download and run the bootstrap directly:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/justinlevinedotme/dotfiles/main/boostrap.sh)"
```

### Environment Variables (Optional)

You can customize the installation by setting these environment variables before running bootstrap:

| Variable | Description | Example |
|----------|-------------|---------|
| `GIT_NAME` | Your name for git commits | `export GIT_NAME="John Doe"` |
| `GIT_EMAIL` | Your email for git commits | `export GIT_EMAIL="john@example.com"` |
| `DOTFILES_DIR` | Where to install dotfiles | `export DOTFILES_DIR="$HOME/.dotfiles"` (default) |
| `DOTFILES_REPO` | Custom dotfiles repo URL | `export DOTFILES_REPO="https://github.com/user/dotfiles"` |
| `GITHUB_USER` | Your GitHub username (used to infer repo) | `export GITHUB_USER="johndoe"` |

Example with custom git identity:
```bash
GIT_NAME="Justin Levine" GIT_EMAIL="justin@example.com" ./boostrap.sh
```

## Bootstrap (full setup)
```bash
./boostrap.sh
```
Installs Homebrew packages, configures Touch ID sudo, git/gh, Node/Rust, runs macOS scripts (Dock, defaults), and then runs Dotbot to link files.

Linked via Dotbot: Zsh, eza/fastfetch/starship/ghostty/zed configs, git config/ignore, Raycast scripts, macOS scripts.
VS Code profile: `~/Library/Application Support/Code/User/profiles/default.code-profile` (exported profile tracked in `config/vscode`).

### What bootstrap installs/does
- Homebrew (and taps `homebrew/cask-fonts`), then casks: Ghostty, Zed, VSCode, Raycast, Dropbox, Helium Browser, Hidden Bar, Raindrop.io, Proton Pass, Discord, Screen Studio, Setapp, Bambu Studio, Folx, Keka, OnyX, plus fonts (Geist/Geist Mono Nerd Font and a suite of popular fonts).
- Homebrew formulae: git, stow, nvm, eza, fastfetch, zoxide, fzf, starship.
- Node: installs nvm, latest LTS node, sets default, installs pnpm.
- Rust: installs rustup (minimal profile, stable toolchain).
- Touch ID for sudo (if available), sets default shell to zsh.
- macOS scripts: Dock setup and defaults from `config/macos`.
- Dotbot: links configs (see Dotfiles section) and cleans stale links in `$HOME`.

## Dotfiles only
```bash
./install
```
Runs Dotbot with `install.conf.yaml` to link everything into `$HOME`.

## Stow (optional)
If you need to stow a specific module instead of Dotbot, you can still do:
```bash
stow config -t ~
```
But Dotbot is the default installer.
