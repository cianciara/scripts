#!/bin/bash

log_file="path_to_your_log_file.log"

# Initialize variables
current_xml=""
processing_xml=0
msgId_pattern="<msgId>([^<]+)</msgId>"
type_pattern="TYPE"

while IFS= read -r line; do
    # Start of a new log entry (adjust regex to match your timestamp format)
    if [[ $line =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
        # Process the accumulated XML block for msgId and TYPE pattern
        if [[ -n $current_xml ]]; then
            # Extract msgId
            if [[ $current_xml =~ $msgId_pattern ]]; then
                msgId="${BASH_REMATCH[1]}"
                # Check for TYPE pattern
                if echo "$current_xml" | grep -q "$type_pattern"; then
                    echo "Found msgId with TYPE: $msgId"
                    # Additional logic for matching msgId in other entries can be added here
                fi
            fi
        fi
        # Reset for the next XML block
        current_xml=""
    fi
    # Accumulate lines of XML
    current_xml+="$line"$'\n'
done < "$log_file"

# Don't forget to process the last XML block
if [[ -n $current_xml && $current_xml =~ $msgId_pattern ]]; then
    msgId="${BASH_REMATCH[1]}"
    if echo "$current_xml" | grep -q "$type_pattern"; then
        echo "Found msgId with TYPE: $msgId"
    fi
fi