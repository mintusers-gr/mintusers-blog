#!/usr/bin/env bash
if [ ! -d /vagrant ]
then
  source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"
  source "$(dirname "${BASH_SOURCE[0]}")/../.env"
else
  source "/vagrant/bin/utils.bash"
  source /vagrant/.env
fi

function checkENV()
{
  local -r txt=$(eval "echo $"{$1})
  if [ "${txt}" == "" ]
  then
    printInfo "There is a problem with the configuration"
    printInfo "Enviroment value ${1} is not set!."
    printInfo "Add a linen your .env secret file.\n${1}=\"...\"\n"
  fi
}

checkENV GIT_NAME
checkENV GIT_EMAIL
checkENV GITHUB_USER

checkENV BOX_IP
checkENV BOX_NAME
checkENV BOX_HOSTNAME

#checkENV BAD_NAME2
