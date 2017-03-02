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
installAptGetPackage "ruby2.4"
installAptGetPackage "ruby2.4-dev"
installAptGetPackage "ruby-switch"
installAptGetPackage "git"
installAptGetPackage "language-pack-el"
installAptGetPackage "liblzma-dev"
installAptGetPackage "zlib1g-dev"
installAptGetPackage "wget"
installAptGetPackage "curl"
installAptGetPackage "zsh"
installAptGetPackage "epiphany-browser"
installAptGetPackage "gitg"
installAptGetPackage "silversearcher-ag"

printInfo  "** Remove orphan packages"
apt-get -y autoremove

printInfo  "** Update System gems"
gem update --system
geminstall bundler
geminstall nokogiri
geminstall haml
geminstall html2haml
geminstall rouge
geminstall redcarpet
geminstall yard
geminstall pry
geminstall guard
geminstall bropages
geminstall jekyll
geminstall github-pages
geminstall middleman
geminstall puma
geminstall github
geminstall github_cli

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

printInfo  "** Setup ZSH"
set +e
sudo -u vagrant chsh -s /usr/bin/zsh
set -e
if [ ! -d /home/vagrant/.oh-my-zsh ] ; then
  sudo -u vagrant -H sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
sudo -u vagrant cp /vagrant/bin/.templates/.zshrc /home/vagrant

printInfo  "** Customize motd"
rm -f /etc/update-motd.d/10-help-text
rm -f /etc/update-motd.d/91-release-upgrade
rm -f /etc/update-motd.d/51-cloudguest
cp /vagrant/bin/.templates/50-landscape-sysinfo /etc/update-motd.d/50-landscape-sysinfo
run-parts /etc/update-motd.d/ > /dev/null

printInfo "** Updating local Gemfile"
cd /vagrant/jekyll-blog
sudo -u vagrant -H bundle install --binstubs --quiet
bundle show

printInfo "** Run as service at startup"
cp /vagrant/bin/.templates/jekyll_service /etc/init.d/jekyll_service
chmod +x /etc/init.d/jekyll_service
update-rc.d jekyll_service defaults
service jekyll_service start

if ! grep -q ${BOX_HOSTNAME} /etc/hosts; then
  echo "Updating /etc/hosts for canonical name $(tput setaf 1)'${BOX_HOSTNAME}'$(tput sgr0) using ip $(tput setaf 1)${BOX_IP}$(tput sgr0)."
  echo -e "\n ${BOX_IP} ${BOX_HOSTNAME} ${BOX_NAME}" >> /etc/hosts
fi
