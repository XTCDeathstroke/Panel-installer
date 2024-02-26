#!/bin/bash

# Update and upgrade system packages
sudo apt update -y && sudo apt upgrade -y

# Set executable permission for scripts
chmod +x install_Dependencies.sh config_PHP.sh config_MariaDB.sh config_MySQL.sh config_NGINX.sh install_Pterodactyl.sh config_Services.sh

# Execute scripts in order
./install_Dependencies.sh || { echo "Failed to execute install_Dependencies.sh"; exit 1; }
./config_PHP.sh || { echo "Failed to execute config_PHP.sh"; exit 1; }
./config_MariaDB.sh || { echo "Failed to execute config_MariaDB.sh"; exit 1; }
./config_MySQL.sh || { echo "Failed to execute config_MySQL.sh"; exit 1; }
./config_NGINX.sh || { echo "Failed to execute config_NGINX.sh"; exit 1; }
./install_Pterodactyl.sh || { echo "Failed to execute install_Pterodactyl.sh"; exit 1; }
./config_Services.sh || { echo "Failed to execute config_Services.sh"; exit 1; }

echo "All scripts executed successfully."
