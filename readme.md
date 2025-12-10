# my dotfiles
A collection of my dotfiles, managed using [GNU Stow](https://www.gnu.org/software/stow/). I use [git-crypt](https://github.com/AGWA/git-crypt) to encrypt my private files, so I can quickly fetch anywhere I need to, without worrying about the security of them.

Stow is amazing because I can just pull this repository, `stow *` and continue. 


## Overview

| Package   | File                | Symlink Location                   | Notes                                  |
| --------- | ------------------- | ---------------------------------- | -------------------------------------- |
| eza       | `theme.yml`         | `~/.config/eza/theme.yml`          | Color theme for eza (ls replacement)   |
| fastfetch | `config.jsonc`      | `~/.config/fastfetch/config.jsonc` | System info display config             |
| ghostty   | `config`            | `~/.config/ghostty/config`         | Terminal emulator settings             |
| git       | `.gitconfig`        | `~/.config/git/.gitconfig`         | Git configuration                      |
| git       | `.gitignore_global` | `~/.config/git/.gitignore_global`  | Global gitignore patterns              |
| git       | `.gitmessage`       | `~/.config/git/.gitmessage`        | Commit message template                |
| starship  | `starship.toml`     | `~/.config/starship.toml`          | Shell prompt configuration             |
| zed       | `settings.json`     | `~/.config/zed/settings.json`      | Zed editor settings                    |
| zsh       | `.zshrc`            | `~/.zshrc`                         | Main zsh configuration                 |
| zsh       | `.zshrc.local`      | `~/.zshrc.local`                   | Local/private zsh settings (encrypted) |