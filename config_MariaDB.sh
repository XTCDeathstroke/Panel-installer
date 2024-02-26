#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Install expect if not already installed
if ! command -v expect &>/dev/null; then
    echo "Expect is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y expect
fi

# Run mysql_secure_installation with default values
if expect <<EOF
spawn mysql_secure_installation
expect "Enter current password for root (enter for none):"
send "password\n"
expect "Change the root password?"
send "n\n"
expect "Remove anonymous users?"
send "Y\n"
expect "Disallow root login remotely?"
send "Y\n"
expect "Remove test database and access to it?"
send "Y\n"
expect "Reload privilege tables now?"
send "Y\n"
expect eof
EOF
then
    echo "MariaDB configuration completed."
    # Initialize variable to track success
    config_MySQL_completed=true
else
    echo "MariaDB configuration failed."
    # Initialize variable to track failure
    config_MySQL_completed=false
    exit 1 # Abort script
fi

# Use config_MySQL_completed variable in further processing if needed
