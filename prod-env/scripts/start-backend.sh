#!/bin/bash

# Go to the directory where the backend is deployed
cd /home/vagrant/artefact-repository/

# Check if backend is running
PID=$(pgrep -f "e4l-server.jar")

if [ -n "$PID" ]; then
    # Kill backend process if running
    sudo kill -15 "$PID"
fi

# Start backend in the background
nohup java -jar e4l-server.jar > /dev/null 2>&1 &