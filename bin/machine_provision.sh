#!/bin/bash

if [ ! -d /vagrant ]
then
  source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"
  printInfo "*************************************************"
  printInfo "* Don't run this on the host machine please!   *"
  printInfo "*************************************************"
  exit
else
  source "/vagrant/bin/utils.bash"
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

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
installAptGetPackage "firefox"
installAptGetPackage "gitg"

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

source /vagrant/.env
if [ "${GIT_NAME}"  == "" ]
then
  printInfo  "** ERROR: Failed to setup git. Please update .env file and run vagrant provision"
  exit
else
  printInfo  "** Setup git and github"
  sudo -u vagrant -H git config --global user.email "${GIT_EMAIL}"
  sudo -u vagrant -H git config --global user.name  "${GIT_NAME}"
  sudo -u vagrant -H git config --global color.ui true
  sudo -u vagrant -H git config --global push.default simple
fi

if ! grep -q shellrc.sh /home/vagrant/.bashrc
then
    echo "source /vagrant/bin/shellrc.sh" >>  /home/vagrant/.bashrc
    printInfo  "** Startup bash file .bashrc updated"
fi

# SSH for github
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
ssh -T git@github.com

# A better github manage tool
printInfo  "** Setup hub tool"
mv /home/vagrant/hub /usr/local/bin/

printInfo  "** Setup zshell"
chsh vagrant -s /usr/bin/zsh

sudo -u vagrant -H sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# activate plugins
sed -i 's/plugins=(git)/plugins=(git,github,ruby)/g' /home/vagrant/.zshrc
echo "source /vagrant/bin/shellrc.sh" >>  /home/vagrant/.zshrc


source "/vagrant/bin/machine_provision_local.sh"
