# dotfiles

My macOS dotfiles managed with GNU Stow.

## Quick Start (New Machine)

For a fresh macOS setup, run the bootstrap script:
```bash
# Set environment variables (optional)
export GITHUB_USER="justinlevinedotme"
export GIT_NAME="Justin Levine"
export GIT_EMAIL="your-email@example.com"

# Run bootstrap
curl -fsSL https://raw.githubusercontent.com/justinlevinedotme/.dotfiles/master/bootstrap.sh | bash
```

This will:
- Install Homebrew, GUI apps, and CLI tools
- Configure Git and GitHub CLI
- Set up Node.js (nvm/pnpm), Rust, and other dev tools
- Run macOS system configuration scripts
- Stow all dotfiles automatically

## Manual Installation

If you already have the tools installed, just stow the configs:

```bash
brew install stow
cd ~/.dotfiles
stow zsh git eza fastfetch ghostty starship zed vscode raycast
```

## Available Packages

- **zsh** - Zsh configuration with Oh My Zsh, aliases, and exports
- **git** - Git configuration and global gitignore
- **eza** - eza color theme (Ghostty-compatible)
- **fastfetch** - System information display config
- **ghostty** - Ghostty terminal emulator settings
- **starship** - Starship prompt configuration
- **zed** - Zed editor settings with Vercel theme
- **vscode** - VS Code settings.json and profile
- **raycast** - Raycast automation scripts
- **macos** - macOS configuration scripts (dock.sh, defaults.sh)

## Usage

Each package is a self-contained directory that mirrors your home directory structure. Stow creates symlinks from `~/.dotfiles/<package>` to `~`.

To unstow a package:
```bash
stow -D <package>
```

To restow (useful after updates):
```bash
stow -R <package>
```
