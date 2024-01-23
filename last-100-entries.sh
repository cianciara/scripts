#!/bin/bash

LOG_FILE="/path/to/your/logfile.log"
entries=$(tail -n 100 "$LOG_FILE")

if echo "$entries" | grep -F "DENIED" > /dev/null; then
    denied_found=true
else
    denied_found=false
fi

last_entry_timestamp=$(echo "$entries" | tail -n 1 | awk '{print $1 " " $2}')

# przekonwertuj timestamp do sekund przed 1970-01-01 00:00:00 UTC
last_entry_seconds=$(date --date="$last_entry_timestamp" +"%s")
current_seconds=$(date +"%s")

# oblicz roznice
difference_hours=$(( (current_seconds - last_entry_seconds) / 3600 ))

# sprawdz czy ostatnie entry jest mlodsze niz 12h
if [ $difference_hours -le 12 ]; then
    recent=true
else
    recent=false
fi

# wyslij mail
if $denied_found && $recent; then
    echo "fine" | mail -s "Status" your-email@example.com
elif ! $recent; then
    echo "alert: last entry older than 12 hours" | mail -s "Status" your-email@example.com
else
    echo "alert: 'DENIED' not found in recent entries" | mail -s "Status" your-email@example.com
fi
