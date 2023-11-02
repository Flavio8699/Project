#!/bin/bash

cd ../../lu.uni.e4l.platform.frontend.dev

# Create a configuration file with variables which can be adapted to the deloyment environment
env=$(cat <<EOF
PUBLIC_PATH=PUBLIC_PATH
API_URL=API_URL
EOF
)
echo "$env" > .env

# Create CI pipeline
pipeline=$(cat <<EOF
image: node:15.14.0

stages:
  - build
  - deploy
  - release

build:
  stage: build
  script:
    - npm i
    - npm uninstall node-sass
    - npm install node-sass@6.0.1
    - npm run build
  artifacts:
    paths:
      - e4l.frontend/web/dist/*

deploy:
  stage: deploy
  tags:
    - stage-vm-shell
  script:
    - cp -r e4l.frontend/web/dist/* /home/vagrant/frontend/html
    - sh /home/vagrant/stage-scripts/configure-frontend.sh

release:
  stage: release
  tags:
    - prod-vm-shell
  script:
    - cp -r e4l.frontend/web/dist/* /home/vagrant/frontend/html
    - sh /home/vagrant/prod-scripts/configure-frontend.sh
  when: manual

EOF
)
echo "$pipeline" > .gitlab-ci.yml

# Create .gitignore file
gitignore=$(cat <<EOF
# Dependency diretory
#node_modules/
EOF
)
echo "$gitignore" > .gitignore

# Install jq for JSON processing (to extract the repository id from the JSON repsonse)
sudo apt-get -y install jq

base_url="http://192.168.33.94/gitlab/api/v4"
private_token="abcdefghijklmnopqrstuvwxyz"
username="Owner"

# Check and delete, then create the frontend repository
frontend_repository_name="lu.uni.e4l.platform.frontend.dev"
project_id=$(curl --header "PRIVATE-TOKEN: ${private_token}" -s "${base_url}/projects/${username}%2F${frontend_repository_name}" | jq -r '.id')
if [ -n "$project_id" ]; then
  curl --header "PRIVATE-TOKEN: ${private_token}" -X DELETE "${base_url}/projects/${project_id}"
  # Add delay of 5 seconds (such that deletion is compeleted before starting to create repo again)
  sleep 5
fi
curl --header "PRIVATE-TOKEN: ${private_token}" -X POST "${base_url}/projects?name=${frontend_repository_name}"

# Check if a .git directory already exists
if [ -d ".git" ]; then
  rm -rf .git
fi

# Configure git user
git config --global user.name "Owner Name"
git config --global user.email "dev@project.com"

# Create git repository and push
git init
git remote add origin http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev.git
git add .
git commit -m "Initial commit"
git push http://Owner:12345678@192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev master
