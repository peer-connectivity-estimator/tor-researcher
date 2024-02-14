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

# Wait for Tor to start
echo "Waiting for Tor to start..."

# Loop until Tor is confirmed to be running
while true; do
	# Execute the is_tor_running.sh script and capture its output
	output=$(./is_tor_running.sh)
	
	# Check if the output indicates Tor is running
	if echo "$output" | grep -q "TOR IS RUNNING"; then
		echo "Tor is up and running."
		break
	else
		echo "Tor is not running yet, checking again in 1 second..."
		sleep 1
	fi
done

# Script ends when Tor is confirmed to be running
echo "run.sh script has completed."
