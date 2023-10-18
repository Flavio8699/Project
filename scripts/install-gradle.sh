

echo "Install Gradle version"
VERSION=6.7.1
wget https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip -P /tmp
sudo apt install unzip
sudo unzip -d /opt/gradle /tmp/gradle-${VERSION}-bin.zip
echo 'export GRADLE_HOME=/opt/gradle/gradle-6.7.1' > /etc/profile.d/gradle.sh
echo 'export PATH=${GRADLE_HOME}/bin:${PATH}' >> /etc/profile.d/gradle.sh
sudo chmod +x /etc/profile.d/gradle.sh
source /etc/profile.d/gradle.sh