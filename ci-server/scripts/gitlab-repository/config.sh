#!/bin/bash

# Send POST request to API using token generated for the user Flavio to create the repository
curl --header "PRIVATE-TOKEN: abcdefghijklmnopqrstuvwxyz" -X POST "http://192.168.33.9/gitlab/api/v4/projects?name=MavenHelloWorldProject"

# Install GitLab Runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# Get runner token
registration_token=$(sudo gitlab-rails runner -e production " puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")

# Register runner (without tags)
sudo gitlab-runner register \
    --non-interactive \
    --url "http://192.168.33.9/gitlab" \
    --registration-token "$registration_token" \
    --description "docker" \
    --tag-list "integration" \
    --executor "docker" \
    --docker-image alpine:latest \
    --run-untagged="true"

# Restart runner
sudo gitlab-runner restart