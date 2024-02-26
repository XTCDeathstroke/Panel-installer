#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Update package lists
sudo apt update

# Install PHP and extensions
sudo apt install -y php php-cli php-gd php-mysql php-pdo php-mbstring php-tokenizer php-bcmath php-xml php-fpm php-curl php-zip

# Enable PHP-FPM
if sudo systemctl enable php-fpm; then
    echo "PHP-FPM enabled."
else
    echo "Failed to enable PHP-FPM."
    exit 1 # Abort script
fi

# Start PHP-FPM
if sudo systemctl start php-fpm; then
    echo "PHP-FPM started."
else
    echo "Failed to start PHP-FPM."
    exit 1 # Abort script
fi

echo "PHP setup completed."
