#!/bin/sh
# inspired by https://github.com/webpro/dotfiles/blob/main/macos/dock.sh

set -e

dockutil --no-restart --remove all

add_if_exists() {
  local app_path="$1"
  [ -e "$app_path" ] && dockutil --no-restart --add "$app_path"
}

add_if_exists "/System/Applications/Finder.app"
add_if_exists "/System/Applications/System Settings.app"

dockutil --no-restart --add '' --type spacer --section apps
add_if_exists "/Applications/Helium Browser.app"
add_if_exists "/Applications/Raindrop.io.app"
dockutil --no-restart --add '' --type spacer --section apps
add_if_exists "/Applications/Zed.app"
add_if_exists "/Applications/Ghostty.app"
add_if_exists "/Applications/Visual Studio Code.app"

dockutil --restart
