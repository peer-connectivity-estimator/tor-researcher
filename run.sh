#!/bin/bash

# Check if an argument is provided; if not, default to desktop
LOG_FILE_PATH="$1"
if [ -z "$LOG_FILE_PATH" ]; then
  LOG_FILE_PATH="~/Desktop/tor.log"
fi

# Run the Tor command with the provided or default log file path, including both "circ" and "net" logging
./src/app/tor --ClientOnly 1 --UseEntryGuards 0 --Log "[circ]info file $LOG_FILE_PATH" --Log "[net]info file $LOG_FILE_PATH"
