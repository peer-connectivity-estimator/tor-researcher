#!/bin/bash

HSDIR="HiddenServiceDir"
TORRC="torrc"
if [ ! -d "$HSDIR" ]; then
	mkdir -p "$HSDIR"
	chmod 700 "$HSDIR"
fi
if [ ! -f "$TORRC" ]; then
	echo "HiddenServiceDir $(pwd)/$HSDIR" > "$TORRC"
	echo "HiddenServicePort 80 127.0.0.1:80" >> "$TORRC"
fi

# Set the application instance password
PASSWORD_FILE="tor_controller_pwd.key"
PASSWORD_CHARS="A-Za-z0-9@#$%&_+"
PASSWORD=$(tr -dc "$PASSWORD_CHARS" < /dev/urandom | fold -w 20 | head -n 1)
echo "$PASSWORD" > "$PASSWORD_FILE"
if [ -f "$PASSWORD_FILE" ]; then
	CONTROL_PASSWORD=$(cat "$PASSWORD_FILE")
	HASHED_PASSWORD=$(tor --hash-password "$CONTROL_PASSWORD" 2>/dev/null | grep "16:")
	if grep -q "HashedControlPassword" "$TORRC"; then
		# Update the existing HashedControlPassword
		sed -i "/HashedControlPassword/c\HashedControlPassword $HASHED_PASSWORD" "$TORRC"
	else
		# Add HashedControlPassword to torrc
		echo "HashedControlPassword $HASHED_PASSWORD" >> "$TORRC"
	fi
	if ! grep -q "^ControlPort" "$TORRC"; then
		echo "ControlPort 9051" >> "$TORRC"
	fi
else
	echo "Control password file ($PASSWORD_FILE) not found."
fi


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
