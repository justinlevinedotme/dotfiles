#!/bin/sh
# Thanks to webpro for parts of this script

echo "🖥️  Configuring macOS System Defaults..."
echo ""

echo "→ Closing System Preferences if open..."
osascript -e 'tell application "System Preferences" to quit'

echo "→ Requesting sudo access..."
sudo -v

echo "→ Starting sudo keep-alive background process..."
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
echo "⚙️  Applying System Preferences..."
echo ""

echo "→ Setting appearance to Dark mode..."
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

echo "→ Disabling audio feedback when volume is changed..."
defaults write com.apple.sound.beep.feedback -bool false

echo "→ Disabling sound effects on boot..."
sudo nvram SystemAudioVolume=" "
sudo nvram StartupMute=%01

echo "→ Showing battery percentage in menu bar..."
defaults write com.apple.menuextra.battery ShowPercent YES

echo "→ Expanding save panel by default..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "→ Expanding print panel by default..."
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "→ Setting default save location to disk (not iCloud)..."
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "→ Auto-quit printer app when print jobs complete..."
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "→ Disabling 'Are you sure you want to open this?' dialog..."
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "→ Disabling crash reporter dialog..."
defaults write com.apple.CrashReporter DialogType -string "none"

echo "→ Setting keyboard illumination timeout to 5 minutes..."
defaults write com.apple.BezelServices kDimTime -int 300

echo "→ Enabling tap to click on trackpad..."
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "→ Requiring password immediately after sleep/screensaver..."
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo ""
echo "📁 Configuring Finder..."
echo ""

echo "→ Keeping folders on top when sorting by name..."
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "→ Setting default search scope to current folder..."
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "→ Disabling file extension change warning..."
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "→ Preventing .DS_Store files on network/USB volumes..."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "→ Disabling empty Trash warning..."
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "→ Expanding Finder info panes by default..."
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true

echo ""
echo "🎯 Configuring Dock..."
echo ""

echo "→ Hiding recent apps from Dock..."
defaults write com.Apple.Dock show-recents -bool false

echo ""
echo "📊 Configuring Activity Monitor..."
echo ""

echo "→ Showing main window on launch..."
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "→ Setting Dock icon to show CPU usage..."
defaults write com.apple.ActivityMonitor IconType -int 5

echo "→ Showing all processes by default..."
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "→ Sorting by CPU usage..."
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

echo ""
echo "🖱️  Configuring Trackpad..."
echo ""

echo "→ Setting natural scroll direction to OFF..."
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo ""
echo "🔄 Restarting affected applications..."
echo ""

for app in "Address Book" "Calendar" "Contacts" "Dock" "Finder" "Mail" "Safari" "SystemUIServer" "iCal"; do
  echo "→ Restarting ${app}..."
  killall "${app}" &> /dev/null || echo "   (${app} not running)"
done

echo ""
echo "✅ macOS defaults configuration complete!"
