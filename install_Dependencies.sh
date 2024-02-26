#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Update apt
if apt update -y; then
    echo "APT updated successfully."
else
    echo "Failed to update APT."
    exit 1 # Abort script
fi

# Install MariaDB
if apt install -y mariadb-common mariadb-server mariadb-client; then
    echo "MariaDB installed successfully."
else
    echo "Failed to install MariaDB."
    exit 1 # Abort script
fi

# Start and enable MariaDB
if systemctl start mariadb && systemctl enable mariadb; then
    echo "MariaDB started and enabled."
else
    echo "Failed to start or enable MariaDB."
    exit 1 # Abort script
fi

# Install PHP 8.0
if apt install -y php8.0 php8.0-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip}; then
    echo "PHP 8.0 installed successfully."
else
    echo "Failed to install PHP 8.0."
    exit 1 # Abort script
fi

# Install Nginx
if apt install -y nginx; then
    echo "Nginx installed successfully."
else
    echo "Failed to install Nginx."
    exit 1 # Abort script
fi

# Install Redis
if apt install -y redis-server; then
    echo "Redis installed successfully."
else
    echo "Failed to install Redis."
    exit 1 # Abort script
fi

# Start and enable Redis
if systemctl start redis-server && systemctl enable redis-server; then
    echo "Redis started and enabled."
else
    echo "Failed to start or enable Redis."
    exit 1 # Abort script
fi

# Install Certbot
if apt install -y certbot; then
    echo "Certbot installed successfully."
else
    echo "Failed to install Certbot."
    exit 1 # Abort script
fi

# Install Composer
if curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; then
    echo "Composer installed successfully."
else
    echo "Failed to install Composer."
    exit 1 # Abort script
fi

echo "Installation completed successfully."
