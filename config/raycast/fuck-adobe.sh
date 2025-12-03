#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Fuck Adobe
# @raycast.mode fullOutput
#
# Optional parameters:
# @raycast.icon images/adobe.png
# @raycast.iconDark images/adobe.png

# Array of known Adobe process names
ADOBE_PROCESSES=(
    "Adobe Creative Cloud"
    "Adobe Desktop Service"
    "Adobe CEF Helper"
    "Adobe CCXProcess"
    "Adobe CC Library"
    "Adobe Photoshop"
    "Adobe Illustrator"
    "Adobe InDesign"
    "Adobe Premiere Pro"
    "Adobe After Effects"
    "Adobe Media Encoder"
    "Adobe Lightroom"
    "Adobe Lightroom Classic"
    "Adobe Acrobat DC"
    "Adobe Acrobat"
    "Adobe XD"
    "Adobe Bridge"
    "Adobe Camera Raw"
    "Adobe Dimension"
    "Adobe Fresco"
    "AdobeIPCBroker"
    "Adobe Update"
    "Adobe Update Helper"
    "AdobeGCClient"
    "AGMService"
    "AGSService"
    "CCLibrary"
    "CCXProcess"
    "CoreSync"
    "Creative Cloud Helper"
    "Creative Cloud Content Manager"
    "Adobe Desktop Service"
    "AdobeIPCBroker"
    "Adobe Desktop Service"
    "Creative Cloud Content Manager"
    "Creative Cloud UI Helper (Renderer)"
    "Creative Cloud Interprocess Service"
    "Creative Cloud Core Service"
    "Creative Cloud"
    "Creative Cloud Helper"
    "Creative Cloud Helper"
    "Creative Cloud Libraries Synchronizer"
    "Creative Cloud UI Helper (GPU)"
    "Creative Cloud UI Helper"
    "Creative Cloud UI Helper"
    "Adobe Creash Processor"
    "Adobe Content Synchronizer"
    "Adobe Content Synchronizer Finder Extension"
)

echo "Searching for Adobe processes..."
echo "--------------------------------"

killed_count=0

processes=$(ps -ef | grep -i "adobe\|creative cloud" | grep -v "grep")

while IFS= read -r line; do
    if [ -n "$line" ]; then
        pid=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | awk '{$1=$2=$3=$4=$5=$6=$7=""; print $0}' | sed 's/^[ \t]*//')
        # echo "DEBUG: Found process - PID: $pid, Name: $name"

        for adobe_proc in "${ADOBE_PROCESSES[@]}"; do
            if echo "$name" | grep -qi "$adobe_proc"; then
                # echo "DEBUG: Match found for $adobe_proc"
                # echo "Killing process: $name (PID: $pid)"

                # Capture both stdout and stderr from kill command
                if ! error=$(kill -9 "$pid" 2>&1); then
                    echo "ERROR: Failed to kill process: $error"
                else
                    ((killed_count++))
                    echo "DEBUG: Successfully killed process"
                fi
                break
            fi
        done
    fi
done <<< "$processes"

echo "--------------------------------"
echo "Killed $killed_count Adobe-related processes"
