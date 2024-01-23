#!/bin/bash

LOG_FILE="/path/to/logfile.log"
START_PATTERN="LogEntryStartPattern"
TX_TYPE="WEB_PURCHASE"

# pobierz z systemu obecną godzinę i oblicz godzinę wcześniej
NOW=$(date +"%Y-%m-%d %H:%M:%S")
ONE_HOUR_AGO=$(date --date="1 hour ago" +"%Y-%m-%d %H:%M:%S")

# zadeklaruj zmienną found, ktora przechowuje wynik wyszukania wzorca (znaleziony czy nie), przekaz zmienne z basha do awk)
# skrypt zakłada, że timestamp jest w pierwszym polu wpisu
found=$(awk -v TX_TYPE="$TX_TYPE" -v now="$NOW" -v oneHourAgo="$ONE_HOUR_AGO" -v startPattern="$START_PATTERN" '
BEGIN { found=0; entry=""; timestamp="" }
{
    if ($0 ~ startPattern) {
        # sprawdz poprzednie entry zanim wezmiesz kolejne
        if (entry ~ /DENIED/ && entry ~ TX_TYPE && timestamp > oneHourAgo && timestamp <= now) {
            found=1
            exit
        }
        # zacznij nowe entry, zakladajac ze zaczyna się od timestampa
        timestamp=$1 " " $2
        entry=$0
    } else {
        entry = entry "\n" $0
    }
}
END {
    # sprawdz ostatnie entry
    if (entry ~ /DENIED/ && entry ~ TX_TYPE && timestamp > oneHourAgo && timestamp <= now)
        found=1
    print found
}
' "$LOG_FILE"

# wyslij email
if [[ $found -eq 1 ]]; then
    echo "fine" | mail -s "Status" your-email@example.com
else
    echo "alert" | mail -s "Status" your-email@example.com
fi