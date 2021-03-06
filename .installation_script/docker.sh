#!/usr/bin/env bash

docker_setup(){
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    sudo usermod -aG docker $USER
}

if prompt_default_yes "Install Docker?"; then
    yay -Sy docker docker-compose;
    docker_setup;
fi
