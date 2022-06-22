#! /bin/bash

#machine state and dependencies

#install git
apt update -y
apt install git -y
echo 'GIT INSTALLATION COMPLETE...WORKING...'

#install curl
apt update -y
apt install curl -y
echo 'CURL INSTALLATION COMPLETE...WORKING...'

#install NVM to use Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

#export and load NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

#specify Node version
nvm install 16.3.0
nvm use 16.3.0

## Clone project into new directory
mkdir /home/student/React_Project/scripts
git clone https://github.com/LaunchCodeTechnicalTraining/react-tic-tac-toe-tutorial.git /home/student/React_Project/scripts/react-tic-tac-toe-tutorial

#move to project directory
cd /home/student/React_Project/scripts/react-tic-tac-toe-tutorial

#build artifacts
#install dependencies
npm i
npm run build

#create directory and move build artifacts
mkdir /home/student/React_Project/react-website
mv /home/student/React_Project/scripts/react-tic-tac-toe-tutorial/build /home/student/React_Project/react-website
echo 'ARTIFACTS BUILT...WORKING...'

#install web server, caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
apt update -y
apt install caddy -y

#stop and restart caddy
systemctl stop caddy
systemctl start caddy
echo 'CADDY INSTALLATION COMPLETE...WORKING...'

#configure caddy
(
cat <<'EOF'
http://localhost {
  root * /home/student/React_Project/react-website/build
  file_server
}
EOF
) > /etc/caddy/Caddyfile

#reload caddy
caddy reload --config /etc/caddy/Caddyfile
echo 'Caddyfile CONFIGURED AND RELOADED...WORKING...'


echo 'READY TO VIEW IN BROWSER  @ http://localhost'
