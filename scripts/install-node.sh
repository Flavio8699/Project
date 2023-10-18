

echo "Install Node 15.14.0 and NPM 7.7.6"
sudo apt-get install -y curl      
mkdir /opt/nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | NVM_DIR=/opt/nvm bash
echo 'export NVM_DIR="/opt/nvm"' > /etc/profile.d/nvm.sh
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/profile.d/nvm.sh
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /etc/profile.d/nvm.sh
sudo chmod 755 /etc/profile.d/nvm.sh
source /etc/profile.d/nvm.sh
nvm install 15.14.0