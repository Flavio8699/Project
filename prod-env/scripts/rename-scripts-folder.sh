#!/bin/bash

# Set new prod env provision scripts location
prod_scripts="/home/vagrant/prod-scripts"

# Check if folder already exists
if [ -d "$prod_scripts" ]; then
    # Delete if exists
    rm -r "$prod_scripts"
fi

# Move scripts to new location
mv /home/vagrant/scripts "$prod_scripts"