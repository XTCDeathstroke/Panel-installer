#!/bin/bash

# Enable error handling - script will exit immediately if any command returns a non-zero exit status
set -e

# Enable and start Redis
if sudo systemctl enable --now redis-server; then
    echo "Redis enabled and started."
else
    echo "Failed to enable and start Redis."
    exit 1 # Abort script
fi

# Enable and start Pterodactyl queue worker service
if sudo systemctl enable --now pteroq.service; then
    echo "Pterodactyl queue worker service enabled and started."
else
    echo "Failed to enable and start Pterodactyl queue worker service."
    exit 1 # Abort script
fi

echo "Redis and Pterodactyl queue worker service enabled and started."
