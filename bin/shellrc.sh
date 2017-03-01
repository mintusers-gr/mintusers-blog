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

function printInfo() {
    local -r message="${1}"
    echo -e "\033[1;36m${message}\033[0m" 2>&1
}

source /vagrant/.env
#PS1="\033[1;36m${BOX_NAME}\033[0m: \w \$ "

cd /vagrant
printInfo "Welcome to ${BOX_HOSTNAME}"

if [ -f /vagrant/bin/shell_local.sh ]
then
  source /vagrant/bin/shell_local.sh
fi
