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

build:
  stage: build
  script:
    - npm i
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
