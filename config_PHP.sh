#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Update package lists
sudo apt update

# Install PHP 8.0 and extensions
sudo apt install -y php8.0 php8.0-cli php8.0-gd php8.0-mysql php8.0-pdo php8.0-mbstring php8.0-tokenizer php8.0-bcmath php8.0-xml php8.0-fpm php8.0-curl php8.0-zip

# Enable PHP-FPM
if sudo systemctl enable php8.0-fpm; then
    echo "PHP-FPM enabled."
else
    echo "Failed to enable PHP-FPM."
    exit 1 # Abort script
fi

# Start PHP-FPM
if sudo systemctl start php8.0-fpm; then
    echo "PHP-FPM started."
else
    echo "Failed to start PHP-FPM."
    exit 1 # Abort script
fi

echo "PHP setup completed."
