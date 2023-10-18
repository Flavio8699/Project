#!/bin/bash

# Replace external_url
sudo sed -i "/external_url/c\external_url 'http://192.168.33.9/gitlab'" /etc/gitlab/gitlab.rb

# Replace port
sudo sed -i "/\# unicorn\['port'\]/c\unicorn\['port'\] = 8088" /etc/gitlab/gitlab.rb

# Reconfigure and restart gitlab
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart unicorn
sudo gitlab-ctl restart

# Change root password
sudo gitlab-rails runner /home/vagrant/scripts/gitlab/set-root-password.rb

# Create non-root user account to host project
sudo gitlab-rails runner /home/vagrant/scripts/gitlab/create-user.rb