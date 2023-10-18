#!/bin/bash

# Add a user to the docker group ot be able to access the docker CLI
sudo usermod -aG docker vagrant

output=$(docker run --name hello-world hello-world)

if [[ $output == *"Hello from Docker!"* ]]; then
    docker rm hello-world
    docker rmi hello-world
    echo "Docker is working."
else
    echo "Docker failed to create hello-world example."
fi