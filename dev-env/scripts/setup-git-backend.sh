#!/bin/bash

cd ../../lu.uni.e4l.platform.api.dev

# Create CI pipeline
pipeline=$(cat <<\EOF
image: gradle:6.7.1-jdk8

stages:
  - build
  - package
  - deploy
  - test
  - release

cache:
  paths:
    - .gradle/wrapper
    - .gradle/caches

variables:
  GRADLE_OPTS: "-Dorg.gradle.daemon=false"
  STAGE_BASE_URL: "https://192.168.33.96"

build:
  stage: build
  script:
    - ./gradlew clean build

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
    - sh /home/vagrant/stage-scripts/start-backend.sh
    - sh /home/vagrant/stage-scripts/configure-backend.sh

acceptance test:
  stage: test
  tags:
    - integration
  services:
    - name: selenium/standalone-chrome:3.141.59
  script:
    - ./gradlew acceptanceTest -Penv.BASEURL=$STAGE_BASE_URL

release:
  stage: release
  tags:
    - prod-vm-shell
  script:
    - cp build/libs/*.jar /home/vagrant/artefact-repository
    - sh /home/vagrant/prod-scripts/start-backend.sh
    - sh /home/vagrant/prod-scripts/configure-backend.sh
  when: manual

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

# Install jq for JSON processing (to extract the repository id from the JSON repsonse)
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

# Check if a .git directory already exists
if [ -d ".git" ]; then
  rm -rf .git
fi

# Create certificate for backend
keytool -genkey -noprompt -dname "CN=e4l, OU=ID, O=UniLU, L=Belval, S=Luxembourg, C=LU" -alias server-alias -keyalg RSA -keypass 12345678 -storepass 12345678 -keystore keystore.jks

# Move certificate
mv keystore.jks src/main/resources/

# Configure git user
git config --global user.name "Owner Name"
git config --global user.email "dev@project.com"

# Create git repository and push
git init
git remote add origin http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev.git
git add .
git commit -m "Initial commit"
git push http://Owner:12345678@192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev master
