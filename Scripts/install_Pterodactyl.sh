#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Move to the directory where the Panel will live
if mkdir -p /var/www/pterodactyl && cd /var/www/pterodactyl; then
    echo "Moved to Pterodactyl directory."
else
    echo "Failed to move to Pterodactyl directory."
    exit 1 # Abort script
fi

# Download Panel files using curl
if curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz; then
    echo "Panel files downloaded successfully."
else
    echo "Failed to download Panel files."
    exit 1 # Abort script
fi

# Unpack the archive
if tar -xzvf panel.tar.gz; then
    echo "Panel archive unpacked successfully."
else
    echo "Failed to unpack Panel archive."
    exit 1 # Abort script
fi

# Set correct permissions on storage/ and bootstrap/cache/ directories
if chmod -R 755 storage/* bootstrap/cache/; then
    echo "Permissions set on storage/ and bootstrap/cache/ directories."
else
    echo "Failed to set permissions on storage/ and bootstrap/cache/ directories."
    exit 1 # Abort script
fi

# Copy environment settings file
if cp .env.example .env; then
    echo "Environment settings file copied."
else
    echo "Failed to copy environment settings file."
    exit 1 # Abort script
fi

# Install core dependencies
if composer install --no-dev --optimize-autoloader; then
    echo "Core dependencies installed."
else
    echo "Failed to install core dependencies."
    exit 1 # Abort script
fi

# Generate a new application encryption key
if php artisan key:generate --force; then
    echo "Application encryption key generated."
else
    echo "Failed to generate application encryption key."
    exit 1 # Abort script
fi

# Set up environment configurations
if php artisan p:environment:setup && php artisan p:environment:database && php artisan p:environment:mail; then
    echo "Environment configurations set up."
else
    echo "Failed to set up environment configurations."
    exit 1 # Abort script
fi

# Setup the database tables and add Nests & Eggs
if php artisan migrate --seed --force; then
    echo "Database tables set up and seeds applied."
else
    echo "Failed to set up database tables or apply seeds."
    exit 1 # Abort script
fi

# Create an administrative user
if php artisan p:user:make; then
    echo "Administrative user created."
else
    echo "Failed to create administrative user."
    exit 1 # Abort script
fi

# Set correct permissions on Panel files
# Adjust permissions based on the web server being used
if [ -f /etc/os-release ] && grep -qi 'centos' /etc/os-release; then
    # CentOS commands
    if chown -R nginx:nginx /var/www/pterodactyl/*; then
        echo "Permissions set for CentOS."
    else
        echo "Failed to set permissions for CentOS."
        exit 1 # Abort script
    fi
else
    # Non-CentOS commands
    if chown -R www-data:www-data /var/www/pterodactyl/*; then
        echo "Permissions set for non-CentOS."
    else
        echo "Failed to set permissions for non-CentOS."
        exit 1 # Abort script
    fi
fi

# Setup queue listener
# Create cronjob for Pterodactyl tasks
if (crontab -l 2>/dev/null; echo "* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1") | crontab -; then
    echo "Cronjob created for Pterodactyl tasks."
else
    echo "Failed to create cronjob for Pterodactyl tasks."
    exit 1 # Abort script
fi

# Create queue worker systemd service
if cat << 'EOF' > /etc/systemd/system/pteroq.service
[Unit]
Description=Pterodactyl Queue Worker
After=redis-server.service

[Service]
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
then
    echo "Queue worker systemd service created."
else
    echo "Failed to create queue worker systemd service."
    exit 1 # Abort script
fi

# Reload systemd and start the queue worker service
if systemctl daemon-reload && systemctl enable pteroq && systemctl start pteroq; then
    echo "Queue worker systemd service enabled and started."
else
    echo "Failed to enable or start queue worker systemd service."
    exit 1 # Abort script
fi

echo "Pterodactyl Panel setup completed."
