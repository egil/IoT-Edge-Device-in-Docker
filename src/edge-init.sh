#!/bin/bash

echo "***Starting Docker in Docker***"

# Updated approach to start Docker
# Check for the presence of docker daemon
pgrep dockerd
if [ $? -ne 0 ]; then
    dockerd &
else
    echo "Docker daemon already running."
fi

# Wait for Docker to initialize
while (! docker stats --no-stream ); do
  echo "Waiting for Docker to launch..."
  sleep 1
done

iotedge config apply -c /etc/aziot/config.toml
