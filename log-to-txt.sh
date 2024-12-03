#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Log to Text File
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📓
# @raycast.packageName Logging

# Documentation:
# @raycast.description "Prompt to log what you're working on and append to a text file in the logs folder."
# @raycast.author My Chiffon Nguyen
# @raycast.authorURL https://raycast.com/chiffonng

# Prerequisites: Raycast (macOS)

# Usage:
# Change the dir_path variable to match your desired log file location.
# Add Script to Raycast to run the script like a command
# * Add Script to Cron Job to run the script every 30 minutes
# crontab -e
# */30 * * * * $HOME/path/to/log-to-txt.sh
# crontab -l

output_dir="$HOME/Downloads/logs"

# Define the log file path
mkdir -p "$output_dir"
log_file_path="$output_dir/$(date '+%Y-%m-%d').txt"
touch "$log_file_path"

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

# Append the entry to the log file
echo "$entry" >> "$log_file_path"

echo "Added entry: $entry"