#!/bin/bash

# Install GitLab Runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# Get runner token
registration_token=$(cat /shared-data/gitlab-runner-token.txt)

# Register runner (without tags)
sudo gitlab-runner register \
    --non-interactive \
    --url "http://192.168.33.94/gitlab" \
    --registration-token "$registration_token" \
    --description "shell" \
    --tag-list "prod-vm-shell" \
    --executor "shell"

# Restart runner
sudo gitlab-runner restart

# Add gitlab-runner user to vagrant's group
sudo usermod -aG vagrant gitlab-runner