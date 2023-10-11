# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "dev-env-e4l"
  
  ENV['LC_ALL']="en_US.UTF-8"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  #config.vm.network "forwarded_port", guest: 8088, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 8088, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.94"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "lu.uni.e4l.platform.api.dev", "/lu.uni.e4l.platform.api.dev"
  config.vm.synced_folder "lu.uni.e4l.platform.frontend.dev", "/lu.uni.e4l.platform.frontend.dev"

  

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  
  
  config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
   	  # vb.gui = true
  
      # Customize the amount of memory on the VM:
        vb.memory = "4096"
        #vb.memory = "16284"
        #vb.memory = "24284"


    	vb.cpus = 2
   end
  
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.	
  
  config.vm.provision "shell", inline: <<-SHELL
     export DEBIAN_FRONTEND="noninteractive"
     sudo apt-get update
     
     echo "Update MySql repository"
     sudo apt-get install -y debconf-utils vim curl
     sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-8.0'
     wget https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb
     sudo -E dpkg -i mysql-apt-config_0.8.10-1_all.deb
     sudo apt-get update
     rm mysql-apt-config_0.8.10-1_all.deb

     echo "Install MySql server"
     sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password 12345678'
     sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/root-pass password 12345678'
     sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 12345678"
     sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 12345678"
     sudo -E apt-get -y install mysql-server --allow-unauthenticated

     echo "Install default Java and OpenJDK"
     sudo apt install default-jre -y
     sudo apt-get install openjdk-8-jdk -y

     echo "Install Gradle version"
     VERSION=6.7.1
     wget https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip -P /tmp
     sudo apt install unzip
     sudo unzip -d /opt/gradle /tmp/gradle-${VERSION}-bin.zip
     echo 'export GRADLE_HOME=/opt/gradle/gradle-6.7.1' > /etc/profile.d/gradle.sh
     echo 'export PATH=${GRADLE_HOME}/bin:${PATH}' >> /etc/profile.d/gradle.sh
     sudo chmod +x /etc/profile.d/gradle.sh
     source /etc/profile.d/gradle.sh

     echo "Install Node 15.14.0 and NPM 7.7.6"
    #  sudo apt-get install -y curl
    #  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
    #  echo 'export NVM_DIR="$HOME/.nvm"' > /etc/profile.d/nvm.sh
    #  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/profile.d/nvm.sh
    #  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /etc/profile.d/nvm.sh
    #  sudo chmod +x /etc/profile.d/nvm.sh
    #  source /etc/profile.d/nvm.sh
    #  nvm install 15.14.0

    #  wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh
    #  sudo chmod +x install.sh
    #  sudo ./install.sh
    #  echo 'export NVM_DIR="$HOME/.nvm"' > /etc/profile.d/nvm.sh
    #  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/profile.d/nvm.sh
    #  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /etc/profile.d/nvm.sh
    #  sudo chmod +x /etc/profile.d/nvm.sh
    #  source /etc/profile.d/nvm.sh
    #  nvm install 15.14.0

     SHELL

      
  
end