#!/bin/bash

# !IMPORTANT CHANGE THIS PATH TO YOUR PATH
SCRIPT_TO_RUN="/mnt/TB/Work/projects/detify/autodownload.bash"

# Time to wait before confirming the track has changed (in seconds)
DEBOUNCE_SECONDS=10

# Store the last confirmed track
LAST_CONFIRMED_TRACK=""
PENDING_TRACK=""

# Function to get current track metadata
get_current_track() {
    ARTIST=$(playerctl --player=spotify metadata artist 2>/dev/null)
    TITLE=$(playerctl --player=spotify metadata title 2>/dev/null)
    echo "$ARTIST - $TITLE"
}

# Start listening for metadata changes
dbus-monitor "interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.mpris.MediaPlayer2.Player'" |
while read -r line; do
    if echo "$line" | grep -q "Metadata"; then
        CURRENT_TRACK=$(get_current_track)

        # Skip if metadata is empty (can happen on stop)
        [[ -z "$CURRENT_TRACK" ]] && continue

        # Ignore if track hasn't changed
        if [[ "$CURRENT_TRACK" == "$LAST_CONFIRMED_TRACK" ]]; then
            continue
        fi

        # Set as pending and wait to confirm
        PENDING_TRACK="$CURRENT_TRACK"
        (
            sleep "$DEBOUNCE_SECONDS"

            # After delay, re-check current track
            RECHECK_TRACK=$(get_current_track)

            # If still the same, confirm change and run script
            if [[ "$RECHECK_TRACK" == "$PENDING_TRACK" && "$RECHECK_TRACK" != "$LAST_CONFIRMED_TRACK" ]]; then
                echo "Confirmed new track: $RECHECK_TRACK"
                "$SCRIPT_TO_RUN" "$RECHECK_TRACK"
                LAST_CONFIRMED_TRACK="$RECHECK_TRACK"
            fi
        ) &
    fi
done

