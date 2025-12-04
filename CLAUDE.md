# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository using **Dotbot** for symlink management. The bootstrap script handles full machine setup including Homebrew packages, shell configuration, and macOS defaults.

## Design System

### Color Palette (Vercel/Geist-inspired)
All configs should use this consistent color palette when applicable:

```
# Standard ANSI Colors
Black:          #000000
Red:            #e46d69
Green:          #76c56c
Yellow:         #ec9d38
Blue:           #72a4f8
Magenta:        #ad78ea
Cyan:           #5ec8b7
White:          #a1a1a1

# Bright Colors
Bright Black:   #676767
Bright Red:     #e46d69
Bright Green:   #76c56c
Bright Yellow:  #ec9d38
Bright Blue:    #72a4f8
Bright Magenta: #ad78ea
Bright Cyan:    #5ec8b7
Bright White:   #ededed

# UI Colors
Background:     #0a0a0a
Foreground:     #ededed
Cursor:         #f6f1fe
Selection BG:   #ffffff
Selection FG:   #ededed
```

### Typography
**Default Font**: Geist Mono Nerd Font (installed via Homebrew as `font-geist-mono-nerd-font`)

Use Geist Mono for all terminal, editor, and code-related configurations. This font is already installed by the bootstrap script and should be the default across:
- Terminal emulators (Ghostty)
- Code editors (Zed, VS Code)
- Any config files that specify fonts

When creating or modifying config files, always use these colors and Geist Mono Nerd Font to maintain visual consistency across the entire system.

## Core Commands

### Full Bootstrap (New Machine Setup)
```bash
./boostrap.sh
```
Installs Homebrew packages, configures system settings, and runs Dotbot to link all dotfiles.

### Dotfiles Only (Update Links)
```bash
./install
```
Runs Dotbot with `install.conf.yaml` to symlink configs into `$HOME`.

### Manual Stow (Alternative)
```bash
stow config -t ~
```
Alternative to Dotbot for manual symlink management (not the default method).

## Architecture

### File Structure
```
.dotfiles/
├── boostrap.sh           # Full system setup script
├── install               # Dotbot runner script
├── install.conf.yaml     # Dotbot configuration (defines all symlinks)
├── Dutifile              # File associations for duti
├── dotbot/               # Dotbot submodule
├── dotbot-duti/          # Dotbot duti plugin submodule
└── config/               # All configuration files
    ├── zsh/              # Zsh configuration
    ├── git/              # Git config and global ignore
    ├── ghostty/          # Ghostty terminal config
    ├── zed/              # Zed editor config
    ├── starship/         # Starship prompt config
    ├── eza/              # eza (ls replacement) config
    ├── fastfetch/        # fastfetch system info config
    ├── vscode/           # VS Code profile export + settings.json
    ├── raycast/          # Raycast scripts
    └── macos/            # macOS system configuration scripts
        ├── dock.sh       # Dock setup (uses dockutil)
        └── defaults.sh   # System defaults
```

### Dotbot Symlink Strategy

`install.conf.yaml` defines all symlink mappings from `config/` to `$HOME`:
- Most configs symlink to `~/.config/<tool>/`
- Zsh config links `~/.zshrc` directly
- Git config links `~/.gitconfig` and `~/.config/git/ignore`
- Raycast scripts link to `~/Documents/Raycast Scripts/`
- VS Code profile links to `~/Library/Application Support/Code/User/profiles/default.code-profile`
- VS Code settings.json links to `~/Library/Application Support/Code/User/settings.json`

**Important**: When adding new config files, always update `install.conf.yaml` to include the symlink mapping.

### Editor Configurations

**VS Code** (config/vscode/):
- `default.code-profile` - Complete profile export with extensions and keybindings
- `.config/Code/User/settings.json` - User settings including:
  - Theme: Vercel (Dark)
  - Font: Geist Mono for editor and terminal
  - Better Comments, Error Lens, Todo Tree configurations
  - Prettier, ESLint, and formatter settings
  - Custom indent rainbow colors (semi-transparent whites)
  - Material Icon Theme

**Zed** (config/zed/.config/zed/):
- `settings.json` - Zed editor configuration
  - Theme: Vercel Dark
  - Font: GeistMono Nerd Font Mono
  - VSCode keymap for familiarity
  - MCP server integrations (GitHub, Context7, browser tools)

Both editors are configured to use Geist Mono and the Vercel/Geist color palette for consistency.

### File Associations (duti)

The `Dutifile` manages macOS file type associations using the `duti` command-line tool via the `dotbot-duti` plugin. Current associations:
- **Browser**: Helium (`net.imput.helium`) - HTML, URLs, HTTP/HTTPS
- **Terminal**: Ghostty (`com.mitchellh.ghostty`) - Shell scripts
- **Code Editor**: Zed (`dev.zed.Zed`) - Most source code, plain text, config files, markdown
- **Alternative**: VS Code (`com.microsoft.VSCode`) - Available but not set by default

To modify file associations, edit `Dutifile` and run `./install`. Format: `<bundle_id> <uti/extension> <role>` where role is typically `all`.

**Important**: macOS requires applications to be launched at least once before they can be registered as default handlers. If you get "error -54" during `./install`, launch each app once, then run `./install` again.

### Bootstrap Script Flow

1. **System Prerequisites**: Xcode CLI tools, Rosetta 2
2. **Homebrew**: Install and tap `homebrew/cask-fonts`
3. **GUI Apps**: Install casks (Ghostty, Zed, VS Code, Raycast, browsers, utilities, fonts)
4. **CLI Tools**: Install formulae (git, stow, nvm, eza, fastfetch, zoxide, fzf, starship, gh, etc.)
5. **fzf**: Install shell keybindings (Zsh only, no bash/fish)
6. **Git Setup**: Configure identity from `$GIT_NAME`/`$GIT_EMAIL` env vars
7. **GitHub CLI**: Run `gh auth login` if not authenticated
8. **Touch ID sudo**: Enable Touch ID for sudo (modifies `/etc/pam.d/sudo_local` or `/etc/pam.d/sudo`)
9. **macOS Scripts**: Execute `config/macos/*.sh` (dock.sh, defaults.sh)
10. **Default Apps**: Set Helium as default browser, Ghostty as terminal
11. **Node/NVM**: Install nvm, latest LTS Node, pnpm
12. **Rust**: Install rustup with minimal profile and stable toolchain
13. **Dotbot**: Clone/update dotfiles repo and run `./install` to symlink configs
14. **Default Shell**: Set Zsh as default shell via `chsh`

### Environment Variables Used by Bootstrap

- `DOTFILES_DIR`: Directory for dotfiles (default: `$HOME/.dotfiles`)
- `DOTFILES_REPO`: Git repo URL to clone (inferred from `$GITHUB_USER` if not set)
- `GITHUB_USER`: GitHub username for inferring dotfiles repo
- `GIT_NAME`: Git user.name (set if not already configured)
- `GIT_EMAIL`: Git user.email (set if not already configured)

### Shell Configuration (Zsh)

The `.zshrc` (config/zsh/.zshrc) includes:
- **Oh My Zsh** with multiple plugins (git, vscode, brew, macos, starship, docker, zoxide, eza, fzf, etc.)
- **PATH setup**: Homebrew (universal + Intel fallback), pnpm, nvm, Rust, Python, Go, VS Code CLI, Bun
- **Tool configurations**: eza colors for Ghostty, zoxide override to `cd`
- **Aliases**: 
  - Navigation: `..`, `...`, `gotogit`, `fmml`, `docs`
  - Git shortcuts: `gs`, `ga`, `gco`, `gcm`, `gpu`, `gsync`, `gclean`
  - GitHub CLI: `pr`, `prview`, `issues`, `repo`
  - Node/npm/pnpm: `nr`, `ni`, `pi`, `prun`, `pdev`, `nuke`, `pnukenpm`
  - Tauri: `tauri:dev`, `tauri:build`, `tauri:clean`
  - Rust: `c`, `cb`, `cr`, `ct`, `cclippy`, `cfmt`
  - Docker: `dps`, `dstop`, `drm`, `drmi`
  - System: `zshconfig`, `zshreload`, `flushdns`, `code.`, `zed`, `serve`
- **Local secrets**: Sources `~/.zshrc.local` if present (not committed to git)

### macOS Configuration Scripts

- **dock.sh**: Uses `dockutil` to clear and rebuild Dock with Finder, System Settings, browsers, editors
- **defaults.sh**: System preferences (not detailed here, but handles macOS defaults)

Both scripts run during bootstrap and can be re-run manually from `config/macos/`.

## Development Workflow

### Adding New Configurations

1. Create config directory under `config/<tool>/`
2. Place config files in the appropriate `.config/<tool>/` structure
3. Update `install.conf.yaml` to add symlink mapping
4. Run `./install` to create symlinks
5. If the tool should be auto-installed, update `boostrap.sh` to add it to `casks` or `formulae` arrays

### Modifying Bootstrap Script

- Keep script idempotent (safe to re-run multiple times)
- Use defensive checks: `command -v`, `[ -d ]`, `|| true` for non-critical commands
- Maintain compatibility with both Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local`)
- Use `set -e` at top to fail fast on errors
- Keep sudo alive with background loop (already implemented)

### Testing Changes

After modifying Dotbot config or bootstrap:
1. Test on a clean macOS VM or use `./install` to verify symlinks
2. For bootstrap changes, test individual sections before full run
3. Check that existing symlinks aren't broken by `dotbot --only` for specific sections

### Git Workflow

- Default branch: `master` (per git status)
- Current branch: `dotbot-migration`
- Commit history shows recent migration from stow to Dotbot

## Tool Versions and Dependencies

- **Dotbot**: Git submodule in `dotbot/` directory
- **Homebrew**: Universal installer (supports both architectures)
- **Node**: Managed via nvm, uses LTS version with pnpm
- **Rust**: Minimal profile via rustup
- **Shell**: Zsh with Oh My Zsh + Starship prompt

## Special Considerations

### VS Code Profile Management
The VS Code profile is tracked as an exported `.code-profile` file at `config/vscode/default.code-profile`. This is a complete profile export including settings, extensions, keybindings, etc.

### Raycast Scripts
Raycast scripts are stored in `config/raycast/` and symlinked to `~/Documents/Raycast Scripts/`. The directory must exist before symlinking (created by shell command in `install.conf.yaml`).

### Global Git Ignore
The global gitignore is set via shell command in `install.conf.yaml`:
```bash
git config --global core.excludesfile "$HOME/.config/git/ignore"
```

### Oh My Zsh Plugins
The .zshrc assumes Oh My Zsh is installed. If not present, bootstrap script should handle this (currently not explicit in bootstrap - may need to be added if Oh My Zsh isn't auto-installed by another method).

### Touch ID for Sudo
The bootstrap script safely modifies PAM configuration to enable Touch ID authentication for sudo. It checks for both `/etc/pam.d/sudo_local` (survives updates) and falls back to `/etc/pam.d/sudo`.
