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

/vagrant/bin/check_config.sh

source /vagrant/.env

# Use hub and not git
eval "$(hub alias -s)"

cd /vagrant
printInfo "Ready!"
echo

