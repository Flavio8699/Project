#!/bin/bash

cd ../../lu.uni.e4l.platform.frontend.dev

# Install npm (create node_modules directory)
#npm install

# Create CI pipeline
pipeline=$(cat <<EOF
image: node:15.14.0

stages:
  - build
  #- package
  #- deploy

build:
  stage: build
  script:
    - npm i
    - npm install node-sass@6.0.1
    - npm run build
  artifacts:
    paths:
      - e4l.frontend/web/dist/*

EOF
)
echo "$pipeline" > .gitlab-ci.yml

# Create .gitignore file
gitignore=$(cat <<EOF
# Dependency diretory
node_modules/
EOF
)
echo "$gitignore" > .gitignore

# Configure git user
git config --global user.name "Owner Name"
git config --global user.email "dev@project.com"

# Create git repository and push
git init
git remote add origin http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev.git
git add .
git commit -m "Initial commit"
git push http://Owner:12345678@192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev master
