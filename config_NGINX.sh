#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Remove default NGINX configuration
rm -f /etc/nginx/sites-enabled/default

# Create pterodactyl.conf file with provided content
if cat << EOF > /etc/nginx/sites-available/pterodactyl.conf
server {
    # Replace the example <domain> with your domain name or IP address
    listen 80;
    server_name <domain>;

    root /var/www/pterodactyl/public;
    index index.html index.htm index.php;
    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/pterodactyl.app-error.log error;

    # allow larger file uploads and longer script runtimes
    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
then
    echo "NGINX configuration file created."
else
    echo "Failed to create NGINX configuration file."
    exit 1 # Abort script
fi

# Symlink the configuration file if not using CentOS
if [ ! -f /etc/os-release ] || ! grep -qi 'centos' /etc/os-release; then
    ln -s /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/pterodactyl.conf
fi

# Test NGINX configuration
if nginx -t; then
    echo "NGINX configuration test successful."
else
    echo "NGINX configuration test failed."
    exit 1 # Abort script
fi

# Restart NGINX
if systemctl restart nginx; then
    echo "NGINX restarted successfully."
else
    echo "Failed to restart NGINX."
    exit 1 # Abort script
fi

echo "NGINX configuration for Pterodactyl completed."
