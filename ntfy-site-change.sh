#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi

DOMAIN=$1
DOMAIN_NO_DOTS=${DOMAIN//./} 
DEFAULT_WAITTIME_SEC=60
WAITTIME_SEC=${2:-$DEFAULT_WAITTIME_SEC}
DEFAULT_NTFY_POSTFIX=""
NTFY_POSTFIX=${3:-$DEFAULT_NTFY_POSTFIX}

URL="https://$DOMAIN"                   # The URL of the website you want to monitor
REFERENCE_FILE="reference_content.txt"  # File where the reference content is stored
NOTIFY_URL="https://ntfy.sh/$DOMAIN_NO_DOTS-site-change$NTFY_POSTFIX"  # ntfy.sh topic URL to send notifications
TEMP_FILE="current_content.txt"         # Temporary file to store current content

echo "URL to watch for changes: $URL"
echo "URL to get notification on changes: $NOTIFY_URL"


get_current_content() {
    # curl -s "$URL" | sha256sum | awk '{print $1}'

    # use sed '$d' to remove the last line. it has a timestamp for some sites
    curl -s "$URL" | sed '$d' | sha256sum | awk '{print $1}'
}

get_reference_hash() {
    if [ ! -f "$REFERENCE_FILE" ]; then
        echo "Error: Reference file does not exist."
        return 1
    fi
    cat "$REFERENCE_FILE"
}

send_notification() {
    local message=$1
    curl -s -X POST "$NOTIFY_URL" -d "$message"
}

update_reference_file() {
    local hash=$1
    echo "$hash" > "$REFERENCE_FILE"
}

initialize_refernce_file_if_not_existant() {
    if [ ! -f "$REFERENCE_FILE" ]; then
        send_notification "No reference content found, storing initial content."
        get_current_content > "$REFERENCE_FILE"
    fi
}

initialize_refernce_file_if_not_existant

while true; do

    current_hash=$(get_current_content)
    reference_hash=$(get_reference_hash)

    if [ "$current_hash" != "$reference_hash" ]; then
        send_notification "The content of the website $URL has changed."
        update_reference_file "$current_hash"
    fi

    sleep $WAITTIME_SEC
done