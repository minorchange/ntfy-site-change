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

initialize_reference_file_if_not_existent() {
    if [ ! -f "$REFERENCE_FILE" ]; then
        send_notification "No reference content found, storing initial content."
        get_current_content > "$REFERENCE_FILE"
    fi
}
