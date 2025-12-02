###############################################
#                   Navigation
###############################################

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# Your GitHub workspace
alias gotogit="cd ~/Documents/GitHub"

# Quick project jumps
alias fmml="cd ~/Documents/GitHub/FMMLoader-26"
alias docs="cd ~/Documents/GitHub/FMMLoader26-Docs"

###############################################
#                   Git
###############################################

alias gs="git status"
alias ga="git add ."
alias gaa="git add -A"
alias gb="git branch"
alias gco="git checkout"
alias gcm="git commit -m"
alias gamend="git commit --amend"
alias gpl="git pull"
alias gp="git push"
alias gpu="git push -u origin HEAD"
alias gsta="git stash"
alias gstaapply="git stash apply"

# Sync fork with upstream (your repos often have upstream links)
alias gsync="git fetch upstream && git merge upstream/main"

# Clean up branches
alias gclean="git branch --merged | grep -v main | xargs git branch -d"

###############################################
#               GitHub CLI (gh)
###############################################

alias pr="gh pr create --fill"
alias prview="gh pr view --web"
alias issues="gh issue list"
alias release="gh release create"
alias repo="gh repo view --web"

###############################################
#                Node / npm / pnpm
###############################################

alias nr="npm run"
alias ni="npm install"
alias nis="npm install --save"
alias nid="npm install --save-dev"

alias pi="pnpm install"
alias prun="pnpm run"
alias pdev="pnpm dev"

alias nuke="rm -rf node_modules && rm -f package-lock.json && npm install"
alias pnukenpm="rm -rf node_modules && rm -f pnpm-lock.yaml && pnpm install"

###############################################
#                     Tauri
###############################################

alias tauri:dev="npm run tauri dev"
alias tauri:build="npm run tauri build"
alias tauri:clean="cargo clean && rm -rf src-tauri/target"

###############################################
#                     Rust
###############################################

alias c="cargo"
alias cb="cargo build"
alias cr="cargo run"
alias ct="cargo test"
alias cclippy="cargo clippy"
alias cfmt="cargo fmt"

###############################################
#                     Python
###############################################

alias python="python3"
alias pip="pip3"
alias venv="python3 -m venv .venv && source .venv/bin/activate"

###############################################
#                     Docker
###############################################

alias d="docker"
alias dps="docker ps"
alias dimg="docker images"
alias dstop="docker stop $(docker ps -aq)"
alias drm="docker rm $(docker ps -aq)"
alias drmi="docker rmi $(docker images -q)"

###############################################
#                     System
###############################################

# Quick edits
alias zshconfig="nano ~/.zshrc"
alias zshreload="source ~/.zshrc"

# Safe deletes
alias rm="rm -i"

# Mac utilities
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

###############################################
#               Productivity
###############################################

# Open current folder in VSCode
alias o.="open ."
alias code.="code ."

# Open current folder in Zed
alias zed="zed ."
# Quick server
alias serve="python3 -m http.server"

###############################################
#               FMML / Building
###############################################

alias fmml:dev="cd ~/Documents/GitHub/FMMLoader-26 && pnpm dev"
alias fmml:actions="cd ~/Documents/GitHub/FMMLoader-26/.github/workflows"

###############################################
#               Fun / QoL
###############################################

alias please="sudo"
alias fuck="sudo !!"
alias shrug='echo "¯\_(ツ)_/¯"'
