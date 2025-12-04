#!/bin/sh
# inspired by https://github.com/webpro/dotfiles/blob/main/macos/dock.sh

set -e

echo "🎯 Configuring macOS Dock..."
echo ""

echo "→ Checking for dockutil..."
if ! command -v dockutil &> /dev/null; then
  echo "❌ dockutil not found. Install with: brew install dockutil"
  exit 1
fi

echo "→ Removing all items from Dock..."
dockutil --no-restart --remove all

add_if_exists() {
  local app_path="$1"
  local app_name=$(basename "$app_path" .app)

  if [ -e "$app_path" ]; then
    echo "→ Adding ${app_name}..."
    dockutil --no-restart --add "$app_path"
  else
    echo "⚠️  Skipping ${app_name} (not installed)"
  fi
}

echo ""
echo "→ Adding system applications..."
add_if_exists "/System/Applications/Finder.app"
add_if_exists "/System/Applications/System Settings.app"

echo ""
echo "→ Adding spacer..."
dockutil --no-restart --add '' --type spacer --section apps

echo ""
echo "→ Adding productivity applications..."
add_if_exists "/Applications/Helium Browser.app"
add_if_exists "/Applications/Raindrop.io.app"

echo ""
echo "→ Adding spacer..."
dockutil --no-restart --add '' --type spacer --section apps

echo ""
echo "→ Adding development applications..."
add_if_exists "/Applications/Zed.app"
add_if_exists "/Applications/Ghostty.app"
add_if_exists "/Applications/Visual Studio Code.app"

echo ""
echo "→ Restarting Dock..."
dockutil --restart

echo ""
echo "✅ Dock configuration complete!"
