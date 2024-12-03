#!/bin/bash

# Required parameters:

# @raycast.schemaVersion 1
# @raycast.title Copy Obsidian Notes to Quartz
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝 
# @raycast.packageName Quartz Utils

# Documentation:
# @raycast.author chiffonng
# @raycast.authorURL https://raycast.com/chiffonng

# Paths to directories, starting from $HOME
OBSIDIAN_NOTES_PATH="/Users/chiffonng/Downloads/obsidian"
QUARTZ_PATH="/Users/chiffonng/Downloads/public/quartz"

# Arrays of included and excluded files
declare -a INCLUDE_FILES
declare -a EXCLUDE_FILES
INCLUDE_FILES=(".gitignore")
EXCLUDE_FILES=("Databases/PDF*/" "Excalidraw/" "Timestamps/" "Templates/" "*Inbox*" ".github*" ".obsidian*" ".*")

QUARTZ_CONTENT_PATH="$QUARTZ_PATH/content"

# Print in colors
print_in_color() {
    local color_code="$1"
    shift
    echo -e "\033[${color_code}m$*\033[0m"
}
echo_warning() {
    print_in_color "33" "$1" 
}
echo_error() {
    print_in_color "31" "$1" # Red for error
}
echo_success() {
    print_in_color "32" "$1" # Green for success
}
echo_info() {
    print_in_color "37" "$1" # White for information
}

# Check if Obsidian notes path exists
if [ ! -d "$OBSIDIAN_NOTES_PATH" ]; then
    echo_error "Obsidian notes path does not exist: $OBSIDIAN_NOTES_PATH"
    exit 1
fi

# Check if Quartz path exists
if [ ! -d "$QUARTZ_PATH" ]; then
    echo_error "Quartz path does not exist: $QUARTZ_PATH"
    exit 1
fi

# Current file path
echo_info "Obsidian notes path: $OBSIDIAN_NOTES_PATH"
echo_info "Quartz path: $QUARTZ_PATH"

# Sync obsidian to content
mkdir -p "$QUARTZ_CONTENT_PATH"

# Build rsync arguments
RSYNC_ARGS=()
for pattern in "${INCLUDE_FILES[@]}"; do
    RSYNC_ARGS+=("--include=$pattern")
done
for pattern in "${EXCLUDE_FILES[@]}"; do
    RSYNC_ARGS+=("--exclude=$pattern")
done


rsync -av --delete "${RSYNC_ARGS[@]}" "$OBSIDIAN_NOTES_PATH/" "$QUARTZ_CONTENT_PATH/"

# Commit and push changes in learn-in-public
cd "$QUARTZ_PATH" || exit
git add .
git commit -m "Sync notes from Obsidian"
git push origin v4
echo_success "Synced notes from Obsidian to Quartz"
exit 0