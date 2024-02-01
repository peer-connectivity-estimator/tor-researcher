#!/bin/bash

# If no argument is provided, run the Tor command without logging
if [ -z "$1" ]; then
  ./src/app/tor -f torrc --RunAsDaemon 1 --ClientOnly 1 --UseEntryGuards 0
else
  # If an argument is provided, use it as the log file path
  LOG_FILE_PATH="$1"
  
  # Run the Tor command with the provided log file path, including both "circ" and "net" logging
  ./src/app/tor -f torrc --RunAsDaemon 1 --ClientOnly 1 --UseEntryGuards 0 --Log "[circ]info file $LOG_FILE_PATH" --Log "[net]info file $LOG_FILE_PATH"
fi
