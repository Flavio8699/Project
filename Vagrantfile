# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Configuration for the CI server
  config.vm.define "ci-server" do |ci|
    ci.vm.box = "ubuntu/xenial64"
    ci.vm.hostname = "ci-server-e4l"

    # Consfigure a private network for the CI server
    ci.vm.network "private_network", ip: "192.168.33.94"

    # Define the provisioning playbook for the Ci server
    ci.vm.provision "ansible" do |ansible|
      ansible.playbook = "./ci-server/playbook/playbook.yml"
      ansible.compatibility_mode = "2.0"
    end
  end

  # Configuration for the development environment
  config.vm.define "dev-env" do |dev|
    dev.vm.box = "ubuntu/xenial64"
    dev.vm.hostname = "dev-env-e4l"

    # Consfigure a private network for the development environment
    dev.vm.network "private_network", ip: "192.168.33.95"

    dev.vm.provision :shell, path: "scripts/update-mysql-repo.sh"
    dev.vm.provision :shell, path: "scripts/install-mysql.sh"
    dev.vm.provision :shell, path: "scripts/install-java.sh"
    dev.vm.provision :shell, path: "scripts/install-gradle.sh"

    # Define the provisioning playbook for the development environment
    dev.vm.provision "ansible" do |ansible|
      ansible.playbook = "./dev-env/playbook/playbook.yml"
      ansible.compatibility_mode = "2.0"
    end
  end

  # Configuration for the staging environment
  config.vm.define "stage-env" do |stage|
    stage.vm.box = "ubuntu/xenial64"
    stage.vm.hostname = "stage-env-e4l"

    # Consfigure a private network for the staging environment
    stage.vm.network "private_network", ip: "192.168.33.96"

    stage.vm.provision :shell, path: "scripts/update-mysql-repo.sh"
    stage.vm.provision :shell, path: "scripts/install-mysql.sh"
    stage.vm.provision :shell, path: "scripts/install-java.sh"
    stage.vm.provision :shell, path: "scripts/install-nginx.sh"

    # Define the provisioning playbook for the staging environment
    stage.vm.provision "ansible" do |ansible|
      ansible.playbook = "./stage-env/playbook/playbook.yml"
      ansible.compatibility_mode = "2.0"
    end
  end

  # Configuration for the production environment
  config.vm.define "prod-env" do |prod|
    prod.vm.box = "ubuntu/xenial64"
    prod.vm.hostname = "prod-env-e4l"

    # Consfigure a private network for the production environment
    prod.vm.network "private_network", ip: "192.168.33.97"

    prod.vm.provision :shell, path: "scripts/update-mysql-repo.sh"
    prod.vm.provision :shell, path: "scripts/install-mysql.sh"
    prod.vm.provision :shell, path: "scripts/install-java.sh"
    prod.vm.provision :shell, path: "scripts/install-nginx.sh"

    # Define the provisioning playbook for the production environment
    prod.vm.provision "ansible" do |ansible|
      ansible.playbook = "./prod-env/playbook/playbook.yml"
      ansible.compatibility_mode = "2.0"
    end
  end

  # Set the environment variable
  ENV['LC_ALL']="en_US.UTF-8"

  # Define the shared folders
  config.vm.synced_folder "lu.uni.e4l.platform.api.dev", "/lu.uni.e4l.platform.api.dev"
  config.vm.synced_folder "lu.uni.e4l.platform.frontend.dev", "/lu.uni.e4l.platform.frontend.dev"
  config.vm.synced_folder "shared-data", "/shared-data"

  # Set the VM provider and configure the VMs (define memory and cpus)
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
   	# vb.gui = true

    # Customize the amount of memory on the VM:
      vb.memory = "4096"
      #vb.memory = "16284"
      #vb.memory = "24284"

    # Customoie the number of CPUs
    vb.cpus = 4
  end

  # Provision all the VMs through the shell
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install --yes python
  	SHELL

end
