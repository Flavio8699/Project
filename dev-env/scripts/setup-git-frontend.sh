#!/bin/bash

cd lu.uni.e4l.platform.frontend.dev

# Create pipeline

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
