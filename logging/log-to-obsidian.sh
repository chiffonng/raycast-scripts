#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Log to Obsidian Daily Note
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📓
# @raycast.packageName Logging

# Documentation:
# @raycast.description "Prompt to log what you're working on and append to Obsidian daily note."
# @raycast.author My Chiffon Nguyen
# @raycast.authorURL https://github.com/chiffonng

# Prerequisites:
# 1. Make sure you have Obsidian & Raycast installed on your Mac.
# 2. Install and enable Advanced URI 
# 3. Change this variable to match your Obsidian vault name

# Usage:
# Add Script to Raycast to run the script like a command
# Add Script to Cron Job to run the script every 30 minutes
# */30 * * * * $HOME/path/to/log-to-obsidian.sh

# Change this to match your Obsidian vault name
vault="obsidian"

# Prompt the user for input
log_entry=$(osascript -e 'Tell application "System Events" to display dialog "What are you doing?" default answer ""' -e 'text returned of result')

# If entry is empty, exit
if [ -z "$log_entry" ]; then
  echo "No entry provided"
  exit 1
fi

# Prepare the entry with a timestamp
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
entry="$timestamp $log_entry"

encode_text() {
  # Encode entry to be URL safe, take argument and replace characters with URL encoded values
  echo "$1" | sed 's/ /%20/g' | sed 's/!/%21/g' | sed 's/#/%23/g' | sed 's/\$/%24/g' | sed 's/\&/%26/g' | sed "s/'/%27/g" | sed 's/(/%28/g' | sed 's/)/%29/g' | sed 's/\*/%2A/g' | sed 's/+/%2B/g' | sed 's/,/%2C/g' | sed 's/\//%2F/g' | sed 's/:/%3A/g' | sed 's/;/%3B/g' | sed 's/=/%3D/g' | sed 's/?/%3F/g' | sed 's/@/%40/g' | sed 's/\[/%5B/g' | sed 's/\]/%5D/g'
}
encoded_entry=$(encode_text "$entry")

# Foreground the Obsidian app
open -a "Obsidian"

# Append the entry to the daily note
# https://publish.obsidian.md/advanced-uri-doc/Actions/Writing
open "obsidian://advanced-uri?vault=$vault&daily=true&data=$encoded_entry&mode=append"

echo "Added entry: $entry"

# Add this script to cron job to run every 30 minutes
# */30 * * * * $HOME/path/to/log-to-obsidian.sh