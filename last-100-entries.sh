#!/bin/bash

# Define the log file path
LOG_FILE="/path/to/your/logfile.log"

# Fetch the last 100 entries
entries=$(tail -n 100 "$LOG_FILE")

# Check for "DENIED" in these entries
if echo "$entries" | grep -F "DENIED" > /dev/null; then
    denied_found=true
else
    denied_found=false
fi

# Get the timestamp of the last entry
# Assuming the timestamp is at the beginning of each log entry and in 'YYYY-MM-DD HH:MM:SS' format
last_entry_timestamp=$(echo "$entries" | tail -n 1 | awk '{print $1 " " $2}')

# Convert timestamp to seconds since 1970-01-01 00:00:00 UTC
last_entry_seconds=$(date --date="$last_entry_timestamp" +"%s")
current_seconds=$(date +"%s")

# Calculate the difference in hours
difference_hours=$(( (current_seconds - last_entry_seconds) / 3600 ))

# Check if the last entry is older than 12 hours
if [ $difference_hours -le 12 ]; then
    recent=true
else
    recent=false
fi

# Decision and sending mail
if $denied_found && $recent; then
    echo "fine" | mail -s "Status" your-email@example.com
elif ! $recent; then
    echo "alert: last entry older than 12 hours" | mail -s "Status" your-email@example.com
else
    echo "alert: 'DENIED' not found in recent entries" | mail -s "Status" your-email@example.com
fi
