#!/bin/bash

# Set new stage env provision scripts location
stage_scripts="/home/vagrant/stage-scripts"

# Check if folder already exists
if [ -d "$stage_scripts" ]; then
    # Delete if exists
    rm -r "$stage_scripts"
fi

# Move scripts to new location
mv /home/vagrant/scripts "$stage_scripts"