#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Run mysql_secure_installation with default values
if mysql_secure_installation <<EOF
Y
YourSecurePassword
YourSecurePassword
Y
Y
Y
Y
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

# Continue with the rest of your script...
