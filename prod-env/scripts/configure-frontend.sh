#!/bin/bash

# Define the location of the frontend
frontend="/home/vagrant/frontend"

# Define the configuration variables
PUBLIC_PATH=""
API_URL="https://192.168.33.97:8080/e4lapi"

# Configure frontend
sed -i -e "s@PUBLIC_PATH@$PUBLIC_PATH@g" "$frontend"/html/js/main.js
sed -i -e "s@PUBLIC_PATH@$PUBLIC_PATH@g" "$frontend"/html/index.html
sed -i -e "s@API_URL@$API_URL@g" "$frontend"/html/js/main.js