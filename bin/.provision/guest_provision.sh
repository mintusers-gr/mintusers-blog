#!/bin/bash
set -e

if [ ! -d /vagrant ]
then
  echo "$(tput setaf 1)*************************************************$(tput sgr0)"
  echo "$(tput setaf 1)* Don't run this on the host machine please!    *$(tput sgr0)"
  echo "$(tput setaf 1)*************************************************$(tput sgr0)"
  exit
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

source /vagrant/bin/.provision/utils.bash
source  /vagrant/.env

# Installing repositories and PPAs
installAptGetPackage "python-software-properties"
if [ ! -f /etc/apt/sources.list.d/nodesource.list ]
then
  printInfo "** Installing nodejs repository"
  curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
else
  printInfo "** Nodejs repository allready installed"
fi

if [ ! -f /etc/apt/sources.list.d/brightbox-ruby-ng-trusty.list ]
then
  printInfo "** Installing brightbox ruby repository"
  apt-add-repository -y ppa:brightbox/ruby-ng
  apt-get -y -qq update
else
  printInfo "** Brightbox ruby repository allready installed"
fi

# Update apt cache
runAptGetUpdate "$((1 * 60 * 60))"

# Install packages
installAptGetPackage "nodejs"
installAptGetPackage "build-essential"
installAptGetPackage "ruby2.2"
installAptGetPackage "ruby2.2-dev"
installAptGetPackage "ruby-switch"
installAptGetPackage "git"
installAptGetPackage "language-pack-el"
installAptGetPackage "liblzma-dev"
installAptGetPackage "zlib1g-dev"
installAptGetPackage "wget"
installAptGetPackage "curl"
installAptGetPackage "zsh"
#installAptGetPackage "epiphany-browser"
#installAptGetPackage "gitg"
installAptGetPackage "silversearcher-ag"
installAptGetPackage "graphviz"
installAptGetPackage "graphviz-dev"
installAptGetPackage "gsfonts"
installAptGetPackage "ditaa"
installAptGetPackage "ccze"
installAptGetPackage "multitail"
installAptGetPackage "inotify-tools"

printInfo  "** Remove orphan packages"
apt-get -y autoremove

printInfo  "** Update System gems"
gem update --system
geminstall bundler
geminstall nokogiri
geminstall yard
geminstall pry
geminstall bropages
geminstall jekyll

# SSH for github
echo "$(tput setaf 1)A password may be asked to unlock SSH key storage. It is safe$(tput sgr0)"
ssh-keyscan -H github.com >> ~/.ssh/known_hosts 2> /dev/null
set +e
# This command will always fail
echo "$(tput setaf 2)Trying to ssh-ing at github.com$(tput sgr0)"
ssh -T git@github.com
set -e

# A better github manage tool
printInfo  "** Setup hub tool"
mv /home/vagrant/hub /usr/local/bin/

printInfo  "** Create log directory"
mkdir -p /var/log/jekyll
chown vagrant /var/log/jekyll

printInfo  "** Setup live-server"
if [ ! -f /usr/bin/live-server ]
then
  npm install -g live-server
fi
sudo -u vagrant ln -sf /vagrant/bin/.templates/.live-server.json /home/vagrant
ln -sf /vagrant/bin/.templates/liveserver /etc/init.d/liveserver
chmod +x /etc/init.d/liveserver
update-rc.d liveserver defaults
service liveserver start


printInfo  "** Customize motd"
rm -f /etc/update-motd.d/10-help-text
rm -f /etc/update-motd.d/91-release-upgrade
rm -f /etc/update-motd.d/51-cloudguest
cp /vagrant/bin/.templates/50-landscape-sysinfo /etc/update-motd.d/50-landscape-sysinfo
run-parts /etc/update-motd.d/ > /dev/null

printInfo "** Updating local Gemfile"
cd /vagrant
sudo -u vagrant -H bundle install --quiet
bundle show

printInfo "** Run as service at startup"
ln -sf /vagrant/bin/.templates/jekyll /etc/init.d/jekyll
chmod +x /etc/init.d/jekyll
update-rc.d jekyll defaults
service jekyll start

printInfo  "** Update /etc/hosts"
if ! grep -q ${BOX_HOSTNAME} /etc/hosts; then
  echo "Updating /etc/hosts for canonical name $(tput setaf 1)'${BOX_HOSTNAME}'$(tput sgr0) using ip $(tput setaf 1)${BOX_IP}$(tput sgr0)."
  echo -e "\n ${BOX_IP} ${BOX_HOSTNAME} ${BOX_NAME}" >> /etc/hosts
fi

printInfo  "** Setup logrotate"
ln -sf /vagrant/bin/.templates/jekyll_log_rotate /etc/logrotate.d/jekyll_log_rotate

set +e
printInfo  "** Setup ZSH"
if [ ! -d /home/vagrant/.oh-my-zsh ] ; then
  sudo -u vagrant -H sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
sudo -u vagrant ln -sf /vagrant/bin/.templates/.zshrc /home/vagrant
usermod -s /usr/bin/zsh vagrant
set -e

printInfo  "** Setup Timezone"
timedatectl set-timezone Europe/Athens

printInfo  "** Server status"
echo "Jekyll :" $(service jekyll status)
echo "Live server :" $(service liveserver status)
