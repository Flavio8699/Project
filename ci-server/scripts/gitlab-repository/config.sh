#!/bin/bash

# Install jq for JSON processing (to extract the repository id from the JSON repsonse)
sudo killall apt apt-get
sudo apt-get -y install jq

base_url="http://192.168.33.94/gitlab/api/v4"
private_token="abcdefghijklmnopqrstuvwxyz"
username="Owner"

# Check and delete, then create the backend repository
backend_repository_name="lu.uni.e4l.platform.api.dev"
project_id=$(curl --header "PRIVATE-TOKEN: ${private_token}" -s "${base_url}/projects/${username}%2F${backend_repository_name}" | jq -r '.id')
if [ -n "$project_id" ]; then
  curl --header "PRIVATE-TOKEN: ${private_token}" -X DELETE "${base_url}/projects/${project_id}"
  # Add delay of 5 seconds (such that deletion is compeleted before starting to create repo again)
  sleep 5
fi
curl --header "PRIVATE-TOKEN: ${private_token}" -X POST "${base_url}/projects?name=${backend_repository_name}"

# Check and delete, then create the frontend repository
frontend_repository_name="lu.uni.e4l.platform.frontend.dev"
project_id=$(curl --header "PRIVATE-TOKEN: ${private_token}" -s "${base_url}/projects/${username}%2F${frontend_repository_name}" | jq -r '.id')
if [ -n "$project_id" ]; then
  curl --header "PRIVATE-TOKEN: ${private_token}" -X DELETE "${base_url}/projects/${project_id}"
  # Add delay of 5 seconds (such that deletion is compeleted before starting to create repo again)
  sleep 5
fi
curl --header "PRIVATE-TOKEN: ${private_token}" -X POST "${base_url}/projects?name=${frontend_repository_name}"

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