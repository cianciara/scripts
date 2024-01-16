#!/bin/bash

# Define the log file path
LOG_FILE="/path/to/your/logfile.log"

# Get current date and one hour ago date
NOW=$(date +"%Y-%m-%d %H:%M:%S")
ONE_HOUR_AGO=$(date --date="1 hour ago" +"%Y-%m-%d %H:%M:%S")

# Search for "DENIED" in the log file within the last hour
if grep -F "DENIED" $LOG_FILE | awk -v now="$NOW" -v oneHourAgo="$ONE_HOUR_AGO" '$0 > oneHourAgo && $0 <= now' > /dev/null; then
    echo "fine" | mail -s "Status" your-email@example.com
else
    echo "alert" | mail -s "Status" your-email@example.com
fi
