#!/bin/bash

# Set new dev env provision scripts location
dev_scripts="/home/vagrant/dev-scripts"

# Check if folder already exists
if [ -d "$dev_scripts" ]; then
    # Delete if exists
    rm -r "$dev_scripts"
fi

# Move scripts to new location
mv /home/vagrant/scripts "$dev_scripts"