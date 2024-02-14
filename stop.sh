#!/bin/bash

echo "Stopping Tor..."

# Start time
start_time=$(date +%s)

# Loop indefinitely
while true; do
	# Execute the is_tor_running.sh script and capture its output
	output=$(./is_tor_running.sh)
	
	# Check if the output indicates Tor is running
	if echo "$output" | grep -q "TOR IS NOT RUNNING"; then
		echo "Tor has been stopped."
		break
	fi

	# Calculate elapsed time
	current_time=$(date +%s)
	elapsed=$((current_time - start_time))

	# If more than 30 seconds have elapsed, send SIGKILL
	if [ $elapsed -ge 30 ]; then
		echo "	Sending SIGKILL..."
		pkill -9 tor
	else
		# Send gentle stop signal
		pkill tor
	fi

	# Wait 1 second before trying again
	sleep 1
done
