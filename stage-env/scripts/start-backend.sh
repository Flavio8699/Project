#!/bin/bash

# Go to the directory where the backend is deployed
cd /home/vagrant/artefact-repository/

# Check if backend is running
PID=$(pgrep -f "e4l-server.jar")

PREVIOUS_SERVER=false

if [ -n "$PID" ]; then
    # Kill backend process if running
    sudo kill -15 "$PID"
    # Indicate that there was a previous server running
    PREVIOUS_SERVER=true
    echo "Shutting down previous backend server.."
fi

 Start backend in the background
#nohup java -jar e4l-server.jar > /dev/null 2>&1 &
echo "Starting backend server.."

# Allow the previous backend to shutdown by giving 5 seconds waiting time
if $PREVIOUS_SERVER; then
    sleep 5
fi

# Sample backend API enpoint
BACKEND_URL="http://192.168.33.96:8080/e4lapi"

# Maximum number of retries
MAX_RETRIES=12

# Delay between retries (in seconds)
RETRY_INTERVAL=5

# Counter for the number of retries
RETRY_COUNT=0

# Loop until the backend is ready or the maximum number of retries is reached
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    # Attempt to make an HTTP request to the backend API endpoint
    if curl -s --head --request GET $BACKEND_URL | grep "200" > /dev/null; then
        echo "Backend is ready."
        exit 0
    else
        echo "Backend is not ready yet. Retrying in $RETRY_INTERVAL seconds..."
        sleep $RETRY_INTERVAL
        RETRY_COUNT=$((RETRY_COUNT + 1))
    fi
done

echo "Backend did not become ready within the allotted time."
exit 1