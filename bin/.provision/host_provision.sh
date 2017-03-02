#!/bin/bash
set -e

if [  -d /vagrant ]
then
  echo "$(tput setaf 1)*************************************************$(tput sgr0)"
  echo "$(tput setaf 1)* Don't run this on the guest machine please!    *$(tput sgr0)"
  echo "$(tput setaf 1)**************************************************$(tput sgr0)"
  exit
fi

source .env
`pwd`/bin/check-jekyll-config

if ! grep -q ${BOX_HOSTNAME} /etc/hosts; then
  echo "Updating /etc/hosts for $(tput setaf 1)'${BOX_NAME}'$(tput sgr0) canonical $(tput setaf 1)'${BOX_HOSTNAME}'$(tput sgr0) using ip $(tput setaf 1)${BOX_IP}$(tput sgr0)."
  echo "$(tput setaf 1)** I need root access for that. Please enter sudo password: $(tput sgr0)"
  echo -e "\n${BOX_IP} ${BOX_HOSTNAME}" >> /etc/hosts
fi

echo "$(tput setaf 1)*** The guest machine is ready to serve!$(tput sgr0)"
echo "$(tput setaf 1)* You may like to try 'guest-login'$(tput sgr0)"
