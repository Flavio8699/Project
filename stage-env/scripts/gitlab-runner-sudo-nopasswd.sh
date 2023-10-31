#!/bin/bash

# Define the path to the sudoers file
file="/etc/sudoers"

# Define the command to add to the file (give gitlab-runner user sudo privileges without password)
command="gitlab-runner ALL=(ALL) NOPASSWD: ALL"

# Add command to the file if necessary
if ! sudo tail -n 1 "$file" | grep -q "$command"; then
    echo "$command" | sudo tee -a "$file"
fi
