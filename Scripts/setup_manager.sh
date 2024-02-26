#!/bin/bash

# Initialize variables to track success
config_MySQL_completed=false
config_PHP_completed=false
config_NGINX_completed=false
install_Pterodactyl_completed=false
config_Services_completed=false

# Run each script
./config_MySQL.sh && config_MySQL_completed=true
./config_PHP.sh && config_PHP_completed=true
./config_NGINX.sh && config_NGINX_completed=true
./install_Pterodactyl.sh && install_Pterodactyl_completed=true
./config_Services.sh && config_Services_completed=true

# Print the status of each script
echo "config_MySQL.sh Completed: $config_MySQL_completed"
echo "config_PHP.sh Completed: $config_PHP_completed"
echo "config_NGINX.sh Completed: $config_NGINX_completed"
echo "install_Pterodactyl.sh Completed: $install_Pterodactyl_completed"
echo "config_Services.sh Completed: $config_Services_completed"
