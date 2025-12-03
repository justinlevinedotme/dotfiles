My dotfiles.

## Structure
- All configs live under `config/` (zsh, git, ghostty, zed, starship, eza, fastfetch, Raycast, macOS scripts).
- Raycast scripts are symlinked into `~/Documents/Raycast Scripts`.

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
