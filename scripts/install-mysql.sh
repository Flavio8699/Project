#!/bin/bash

echo "Install MySql server"
sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password 12345678'
sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/root-pass password 12345678'
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 12345678"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 12345678"
sudo -E apt-get -y install mysql-server --allow-unauthenticated