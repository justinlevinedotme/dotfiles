#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Fuck AdobeBloat
# @raycast.mode fullOutput
#
# Optional parameters:
# @raycast.icon images/adobe.png
# @raycast.iconDark images/adobe.png

# --- PASSWORD POPUP FOR RAYCAST ---
ASKPASS_SCRIPT=$(mktemp)
cat << 'EOF' > "$ASKPASS_SCRIPT"
#!/bin/bash
osascript -e 'Tell application "System Events" to display dialog "Enter your macOS password for sudo:" default answer "" with hidden answer buttons {"OK"} default button 1' | awk -F "text returned:" '{print $2}'
EOF
chmod +x "$ASKPASS_SCRIPT"
export SUDO_ASKPASS="$ASKPASS_SCRIPT"

# Always require password
sudo -k

echo "🔐 Authentication required…"
sudo -A -v || exit 1
echo "✔ Authenticated"
echo

echo "💀 Fuck Adobe — Disabling Background Garbage…"
echo

paths=(
    "/Library/LaunchAgents"
    "$HOME/Library/LaunchAgents"
    "/Library/LaunchDaemons"
)

echo "📌 Closing Adobe apps..."
sudo -A pkill -9 -f "Adobe" >/dev/null 2>&1
sudo -A pkill -9 -f "Creative Cloud" >/dev/null 2>&1
sudo -A pkill -9 -f "Core Sync" >/dev/null 2>&1
sleep 1
echo "✔ Adobe apps terminated"
echo

for p in "${paths[@]}"; do
    if [[ -d "$p" ]]; then
        echo "📂 Checking: $p"

        disabled="$p/AdobeDisabled"

        if [[ ! -d "$disabled" ]]; then
            echo "   ➕ Creating $disabled"
            sudo -A mkdir "$disabled"
        fi

        shopt -s nullglob
        plist_files=("$p"/com.adobe*.plist "$p"/*Adobe*.plist)

        if (( ${#plist_files[@]} == 0 )); then
            echo "   ✔ No Adobe plist files found"
        else
            echo "   ➡ Moving Adobe plist files to AdobeDisabled…"
            for f in "${plist_files[@]}"; do
                echo "     - $(basename "$f")"
                sudo -A mv "$f" "$disabled/"
            done
        fi
        echo
    else
        echo "📂 Skipping (folder not found): $p"
        echo
    fi
done

echo "🛑 Killing lingering Adobe processes..."
sudo -A ps aux | grep -i adobe | grep -v grep | awk '{print $2}' | xargs -I{} sudo -A kill -9 {} 2>/dev/null
echo "✔ Processes cleaned"
echo

echo "ℹ AdobeIPCBroker may restart — ignore it."
echo "🎉 All Adobe background shit disabled."
echo
echo "Done."

# Cleanup
rm "$ASKPASS_SCRIPT"
