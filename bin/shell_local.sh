#!/usr/bin/env bash

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

printInfo "** Updating local Gemfile"
cd /vagrant/blog
sudo -u vagrant bundle install
bundle show

printInfo "Ready!"