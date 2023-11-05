#!/bin/bash

# Install GitLab Runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# Get runner token
registration_token=$(sudo gitlab-rails runner -e production " puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")

# Save GitLab runner token in shared file
echo $registration_token > /shared-data/gitlab-runner-token.txt

# Register runner (without tags)
sudo gitlab-runner register \
    --non-interactive \
    --url "http://192.168.33.94/gitlab" \
    --registration-token "$registration_token" \
    --description "docker" \
    --tag-list "integration" \
    --executor "docker" \
    --docker-image alpine:latest \
    --run-untagged="true"

# Restart runner
sudo gitlab-runner restart