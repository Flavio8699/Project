#!/bin/bash

cd ../../lu.uni.e4l.platform.api.dev

# Create CI pipeline
pipeline=$(cat <<EOF
image: gradle:6.7.1

stages:
  - build
  - test
  - package
  - deploy

cache:
  paths:
    - .gradle/wrapper
    - .gradle/caches

variables:
  GRADLE_OPTS: "-Dorg.gradle.daemon=false"

build:
  stage: build
  script:
    - ./gradlew clean build

test:
  stage: test
  script:
    - ./gradlew test

package:
  stage: package
  script:
    - ./gradlew bootJar
  artifacts:
    paths:
      - build/libs/*.jar

deploy:
  stage: deploy
  tags:
    - stage-vm-shell
  script:
    - cp build/libs/*.jar /home/vagrant/artefact-repository
    #- java -jar /home/vagrant/artefact-repository/e4l-server.jar
EOF
)
echo "$pipeline" > .gitlab-ci.yml

# Create .gitignore file
gitignore=$(cat <<EOF
#*.gradle
**/build/
!src/**/build/

# Ignore Gradle GUI config
gradle-app.setting

# Avoid ignoring Gradle wrapper jar file (.jar files are usually ignored)
!gradle-wrapper.jar

# Avoid ignore Gradle wrappper properties
!gradle-wrapper.properties

# Cache of project
.gradletasknamecache

# Eclipse Gradle plugin generated files
# Eclipse Core
.project
# JDT-specific (Eclipse Java Development Tools)
.classpath
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
git remote add origin http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev.git
git add .
git commit -m "Initial commit"
git push http://Owner:12345678@192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev master
