#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

debInst() {
    dpkg-query -Wf'${db:Status-abbrev}' "$1" 2>/dev/null | grep -q '^i'
}

echo -e "${RED}Installing Virtual box and vagrant${NC}"

VBOX_PACKAGE="virtualbox-5.1"
printf "${GREEN} ** Installing VirtualBox${NC}: "
if debInst $VBOX_PACKAGE; then
    printf "  Package ${VBOX_PACKAGE} is installed\n"
else
    printf " ... installing\n"
    sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian trusty contrib"
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install -y dkms
    sudo apt-get install -y ${VBOX_PACKAGE}
fi

printf "${GREEN} ** Installing Vagrant${NC}: "
if debInst "vagrant"; then
    printf "  is installed\n"
else
    printf " ... installing\n"
    sudo apt-get install vagrant
    echo "${GREEN} *** Installing vagrant plugins${NC}"
    sudo vagrant plugin install vagrant-vbguest
    sudo vagrant plugin install vagrant-hostmanager
fi

echo -e "${GREEN} ** Running Vagrant${NC}"
vagrant up

echo -e "${GREEN} ** ALL Done${NC}"
echo "Issue :"
echo "   vagrant ssh"
echo "to login to your new machine"
