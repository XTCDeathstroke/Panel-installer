#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Enable PHP-FPM
if systemctl enable php8.0-fpm; then
    echo "PHP-FPM enabled."
else
    echo "Failed to enable PHP-FPM."
    exit 1 # Abort script
fi

# Start PHP-FPM
if systemctl start php8.0-fpm; then
    echo "PHP-FPM started."
else
    echo "Failed to start PHP-FPM."
    exit 1 # Abort script
fi

echo "PHP setup completed."
