#!/usr/bin/env zsh
# -*- mode: bash -*-
# vi: set ft=bash :
# autoenv module usually do this, but just in case
# Load configuration

if [ -f $(git rev-parse --show-cdup)/.env ] ; then
  source $(git rev-parse --show-cdup)/.env
fi

# No one likes cows
export ANSIBLE_NOCOWS=1

function add_to_path () {
   if ! echo $PATH | /bin/grep -Eq "(^|:)$1($|:)" ; then
     export PATH=$1:$PATH
   fi
}
add_to_path `pwd`/bin

# Banner
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e "Local project URL http://${BOX_HOSTNAME}:4000 running on ${BOX_IP}"
echo -e "   * Run '$(tput setaf 6)guest-login$(tput sgr0)'         to login into the virtual machine"
echo -e "   * Run '$(tput setaf 6)check-config$(tput sgr0)' to check your configuration"
echo -e "   * Run '$(tput setaf 6)vagrant up$(tput sgr0)'          to start the blog"
echo -e "   * Run '$(tput setaf 6)vagrant halt$(tput sgr0)'        to stop the virtual machine"
echo -e "   * Run '$(tput setaf 6)vagrant suspend$(tput sgr0)'     to suspend the virtual machine"
echo
