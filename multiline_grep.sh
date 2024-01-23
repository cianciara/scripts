#!/bin/bash

LOG_FILE="/path/to/logfile.log"
START_PATTERN="LogEntryStartPattern"
TX_TYPE="WEB_PURCHASE"

# pobierz aktualna date i godzine
NOW=$(date +"%Y-%m-%d %H:%M:%S")
ONE_HOUR_AGO=$(date --date="1 hour ago" +"%Y-%m-%d %H:%M:%S")

# przefiltruj wpisy w logu po dacie zakladajac, ze zaczynaja sie od daty i godziny
entries_from_last_hour=$(awk -v startPattern="$START_PATTERN" -v oneHourAgo="$ONE_HOUR_AGO" -v now="$NOW" '
$0 ~ startPattern {
    timestamp=$1 " " $2
}
timestamp > oneHourAgo && timestamp <= now {print}
' "$LOG_FILE")

# sprawdz czy we wpisie znajduje się DENIED i typ transakcji
echo "$entries_from_last_hour" | grep -Pzo "$START_PATTERN([\\s\\S]*?)DENIED([\\s\\S]*?)$TX_TYPE([\\s\\S]*?)$START_PATTERN" > /dev/null
found=$?

# wyslij email
if [[ $found -eq 0 ]]; then
    echo "alert" | mail -s "Status" your-email@example.com
else
    echo "fine" | mail -s "Status" your-email@example.com
fi
