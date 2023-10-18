#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
echo "Update MySql repository"
sudo apt-get install -y debconf-utils vim curl
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-8.0'
wget https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb
sudo -E dpkg -i mysql-apt-config_0.8.10-1_all.deb
sudo apt-get update
rm mysql-apt-config_0.8.10-1_all.deb