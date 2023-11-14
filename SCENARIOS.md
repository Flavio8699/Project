# Scenario 1

## Goal
Deploy a mistake in the frontend to the production and roll-back to the latest correct version.

## Pre-conditions
1. The CI Server is up and running.
2. The Development Environment VM is up and running.
3. The Staging Environment VM is up and running.
4. The Production Environment VM is up and running.
5. There is already a frontend version deployed in production.

## Main Success Scenario
1. SSH into the Development Environment

   ```shell
   vagrant ssh dev-env
   ```

2. Go to the directory containing the frontend source code

   ```shell
   cd /lu.uni.e4l.platform.frontend.dev
   ```

3. Open the `src/js/presentation/NavBar.js` file with a text editor

   ```shell
   nano src/js/presentation/NavBar.js
   ```

4. Replace line 53

   ```
   Energy4Life
   ```

   by

   ```
   Energy2^2Life
   ```

5. Save and exit the text editor<sup>1</sup>

6. Check in the changes to the VSC (GitLab)

   ```shell
   git config --global user.name "Owner Name"
   git config --global user.email "dev@project.com"
   git add src/js/presentation/NavBar.js
   git commit -m "Update navigation bar"
   git push http://Owner:12345678@192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev master
   ```

7. Check if the pipeline (accessible [here](http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev/-/pipelines)) has successfully deployed the frontend to the staging environment and manually release it to the production environment by executing the release task of the pipeline.

8. Check if the changes are visible in production (frontend accessible [here](http://192.168.33.97/))

9. You detected the mistake in production, i.e. the navigation bar displays *Energy2^2Life* instead of *Energy4Life*.  To fix it, go back to the pipelines (accessible [here](http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.frontend.dev/-/pipelines)) and select the latest correct release (by selecting the corresponding pipeline).

10. **Roll-back**: Re-release the frontend by manually executing the release stage of the pipeline again.

11. Check if the roll-back was successful, i.e. the navigation bar displays *Energy4Life* again (frontend accessible [here](http://192.168.33.97/)).

## Notes
1. On MacOS, to save and exit a file using the text editor nano, you have to press <kbd>Ctrl</kbd> + <kbd>X</kbd> followed by <kbd>Y</kbd> and then <kbd>Enter</kbd> to confirm.

# Scenario 2

## Goal
The acceptance test in the pipeline for the backend repository fails due to a mistake in the deploy stage (backend is deployed but not started) in the staging environment.

## Pre-conditions
1. The CI Server is up and running.
2. The Development Environment VM is up and running.

## Main Success Scenario
1. Reload the Staging Environment

   ```shell
   vagrant reload stage-env
   ```

2. SSH into the Development Environment

   ```shell
   vagrant ssh dev-env
   ```

3. Go to the directory containing the backend source code

   ```shell
   cd /lu.uni.e4l.platform.api.dev
   ```

4. Open the `.gitlab-ci.yml` pipeline file with a text editor

   ```shell
   nano .gitlab-ci.yml
   ```

5. Replace line 38

   ```shell
   - sh /home/vagrant/stage-scripts/start-backend.sh
   ```

   by

   ```shell
   #- sh /home/vagrant/stage-scripts/start-backend.sh
   ```

6. Save and exit the text editor<sup>1</sup>

7. Check in the changes to the VSC (GitLab)

   ```shell
   git config --global user.name "Owner Name"
   git config --global user.email "dev@project.com"
   git add .gitlab-ci.yml
   git commit -m "Update pipeline"
   git push http://Owner:12345678@192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev master
   ```

8. Check if the acceptance test in the pipeline that was triggered by the commit has failed (pipeline accessible [here](http://192.168.33.94/gitlab/Owner/lu.uni.e4l.platform.api.dev/-/pipelines))

## Notes
1. On MacOS, to save and exit a file using the text editor nano, you have to press <kbd>Ctrl</kbd> + <kbd>X</kbd> followed by <kbd>Y</kbd> and then <kbd>Enter</kbd> to confirm.
