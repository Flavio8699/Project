#!/bin/bash

cd lu.uni.e4l.platform.api.dev

# Configure git user
git config --global user.name "Owner Name"
git config --global user.email "dev@project.com"

# Create git repository and push
git init
git remote add origin http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev.git
git add .
git commit -m "Initial commit"
git push -u origin master