#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Login to MySQL
if mysql -u root -p <<EOF
CREATE USER 'pterodactyl'@'127.0.0.1' IDENTIFIED BY 'password';
CREATE DATABASE panel;
GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'127.0.0.1';
CREATE USER 'pterodactyluser'@'127.0.0.1' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'pterodactyluser'@'127.0.0.1' WITH GRANT OPTION;
EOF
then
    echo "Database for Pterodactyl created and configured."
    # Initialize variable to track success
    config_MySQL_completed=true
else
    echo "Failed to create and configure database for Pterodactyl."
    # Initialize variable to track failure
    config_MySQL_completed=false
    exit 1 # Abort script
fi

# Use config_MySQL_completed variable in further processing if needed

# Continue with the rest of your script...
