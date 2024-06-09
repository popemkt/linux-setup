#!/bin/bash

# Set the path to your Python script
script_path="$(dirname "$0")/script.py"

# Set the destination directory
destination_dir="$HOME/.popemkt/btfs"

# Set the cron schedule based on the parameter
if [[ "$1" == "--test" ]]; then
    cron_schedule="* * * * *"
    echo "Test mode activated."
else
    cron_schedule="0 21 * * *"
fi

# Set the cron command
cron_command="/usr/bin/python3 $destination_dir/script.py"

# Create the destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Copy the Python script to the destination directory
cp "$script_path" "$destination_dir/script.py"

# Check if the cronjob already exists
if crontab -l | grep -q "$cron_command"; then
    (crontab -l | sed "/$cron_command/d"; echo "$cron_schedule $cron_command") | crontab -
    echo "Cronjob replaced successfully."
else
    # Add the cronjob
    (crontab -l 2>/dev/null; echo "$cron_schedule $cron_command") | crontab -
    echo "Cronjob added successfully."
fi