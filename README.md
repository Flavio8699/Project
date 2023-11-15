# Software Engineering Environments DevOps Project
This is a DevOps project demonstrating the various steps to deliver a product from development to release through a continuous integration (CI) deployment pipeline.

1. [Prerequisites](#1-prerequisites)
2. [Setup](#2-setup)
3. [CI Server](#3-ci-server)
4. [Development Environment](#4-development-environment)
5. [Staging Environment](#5-staging-environment)
6. [Production Environment](#6-production-environment)

## 1. Prerequisites

### Hardware
1. 16GB of memory (ideally 32GB)
2. Quadcore processor (ideally 8-core processor)

### Software
1. Unix-based OS (no Apple Silicon chip)
2. VirtualBox (v6.0 or higher)
3. Vagrant (v2.2.5 or higher)
4. Ansible (v.2.7.5 or higher)

## 2. Setup
1. Go to the folder of your choice and clone the repository:

   ```shell
   git clone https://github.com/Flavio8699/mics-see-project.git
   ```

2. Get into the working directory (root directory of repository):

   ```shell
   cd mics-see-project
   ```

3. Create the shared folder in the working directory (to store and share the runner token between the environments):

   ```shell
   mkdir shared-data
   ```

4. Setup the Deployment Pipeline
   ```shell
   vagrant up
   ```

**Notes:**
- Step 4 starts the CI Server as well as the development, staging and production environments.
- After following the steps above and completing step 4, the Deployment Pipeline and all its related components are up and running.
- A detailed explanation for each environment can be found in the following sections.
- Steps 1-3 are still required even if you want to start all the VMs manually (i.e. you skip step 4 and follow the guidelines in the following sections).
- The project was tested on a Macbook Pro 16" with the following specs:
   - Processor: 2,4 GHz 8-Core Intel Core i9
   - Memory: 32GB
   - Operating System: MacOS Sonoma 14.1
- The machine specified above took 25 minutes to run the `vagrant up` command. More precisely:
   - the start of the *CI Server* took *12 minutes*
   - the start of the *Development Environment VM* took *4 minutes*
   - the start of the *Staging Environment VM* took *4,5 minutes*
   - the start of the *Production Environment VM* took *4,5 minutes*

## 3. CI Server

### Asset Composition
1. Vagrant VM specification (Vagrantfile)
2. Ansible playbooks and shell scripts to provision the VM
3. GitLab as VSC running in the VM
4. Docker service running in the VM
5. GitLab-runner based on docker

### Guidelines
**Note:** Not necessary if you performed step 4 of Section 2.

1. Start the CI Server:
   ```shell
   vagrant up ci-server
   ```

### **** Test Case ****

#### Initial conditions:
1. The CI Server is up and running.

#### Test steps:
1. Go to http://192.168.33.94/gitlab
2. Log in with the following credentials:
   - username: `Owner`
   - password: `12345678`

#### Post conditions:
1. You successfully logged in with the non-root account that will hold the project repositories.

## 4. Development Environment

### Asset Composition
1. Vagrant VM specification (Vagrantfile)
2. Ansible playbooks and shell scripts to provision the VM
3. Java v1.8
4. MySQL v8.0.25
5. Gradle v6.7.1
6. Node v15.14.0
7. NPM v7.7.6
8. Folder _/lu.uni.e4l.platform.frontend.dev_ with the frontend repository
9. Folder _/lu.uni.e4l.platform.api.dev_ with the backend repository

### Guidelines
**Note:** Not necessary if you performed step 4 of Section 2.

1. Start the Development Environment VM:
   ```shell
   vagrant up dev-env
   ```

### **** Test Case ****

#### Initial conditions:
1. The CI Server is up and running.
2. The Development Environment VM is up and running.

#### Test steps:
1. Go to http://192.168.33.94/gitlab
2. If not already logged in, log in with the following credentials:
   - username: `Owner`
   - password: `12345678`
3. Verify that the repository _lu.uni.e4l.platform.api.dev_ (accessible [here](http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev)) exists
4. Verify that the repository _lu.uni.e4l.platform.frontend.dev_ (accessible [here](http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev)) exists

#### Post conditions:
1. The project repositories of the backend and frontend were successfully created during the provisioning of the Development Environment.

## 5. Staging Environment
**Note:** To save resources, the Development Environment VM can be stopped using the command `vagrant halt dev-env`.

### Asset Composition
1. Vagrant VM specification (Vagrantfile)
2. Ansible playbooks and shell scripts to provision the VM
3. File _gitlab-runner-token.txt_ in folder _/shared-data_
4. GitLab-runner based on shell
5. Nginx v1.10.3
6. MySQL v8.0.25
7. Java v1.8

### Guidelines
**Note:** Not necessary if you performed step 4 of Section 2.

1. Start the Staging Environment VM:
   ```shell
   vagrant up stage-env
   ```

### **** Test Case ****

#### Initial conditions:
1. The CI Server is up and running.
2. The Staging Environment VM is up and running.

#### Test steps:
1. For each repository:
   - Open the repository
   - In the sidebar menu, click on CI/CD
   - Click on the status of the first (and only) pipeline (accessible here: [frontend](http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev/-/pipelines/2) or [backend](http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev/-/pipelines/1))
   - Wait and check if the _Deploy_ stage of the pipeline has passed
2. Go to http://192.168.33.96/

#### Post conditions:
1. The product was successfully deployed to the Staging Environment.

## 6. Production Environment
**Note:** To save resources, the Development and Staging Environment VMs can be stopped using the respective commands `vagrant halt dev-env` and `vagrant halt stage-env`.

### Asset Composition
1. Vagrant VM specification (Vagrantfile)
2. Ansible playbooks and shell scripts to provision the VM
3. File _gitlab-runner-token.txt_ in folder _/shared-data_
4. GitLab-runner based on shell
5. Nginx v1.10.3
6. MySQL v8.0.25
7. Java v1.8

### Guidelines
**Note:** Not necessary if you performed step 4 of Section 2.

1. Start the Production Environment VM:
   ```shell
   vagrant up prod-env
   ```

### **** Test Case ****

#### Initial conditions:
1. The CI Server is up and running.
2. The Production Environment VM is up and running.
3. The product was successfully deployed on the Staging Environment and passed the User-Acceptance tests.

#### Test steps:
1. For each repository:
   - Open the repository
   - In the sidebar menu, click on CI/CD
   - Click on the status of the first (and only) pipeline (accessible here: [frontend](http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev/-/pipelines/2) or [backend](http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev/-/pipelines/1))
   - Manually release the product to the Production Environment by clicking on the play-button (next to _'release'_) in the _Release_ stage
2. Go to http://192.168.33.97/

#### Post conditions:
1. The product was successfully released to the Production Environment.
