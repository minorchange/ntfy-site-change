#!/bin/bash

# Determine the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the configuration and functions
source "$SCRIPT_DIR/ntfy-site-change-config.sh" "$@"
source "$SCRIPT_DIR/ntfy-site-change-functions.sh"

# Ensure the reference file is initialized
initialize_reference_file_if_not_existent

# Check for changes once
current_hash=$(get_current_content)
reference_hash=$(get_reference_hash)

if [ "$current_hash" != "$reference_hash" ]; then
    send_notification "The content of the website $URL has changed."
    update_reference_file "$current_hash"
fi
