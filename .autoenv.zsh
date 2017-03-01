# -*- mode: bash -*-
# vi: set ft=bash :

# Load configuration
source .env

# No one likes cows
export ANSIBLE_NOCOWS=1

# Alias
ssh_cmd=`pwd`/bin/guest-login
alias ssh-guest="${ssh_cmd}"

# Banner
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e "Local project URL http://${BOX_HOSTNAME}:4000 running on ${BOX_IP}"
echo -e "   Run '${GREEN}vagrant up${NC}'       to start the blog"
echo -e "   Run '${GREEN}vagrant suspend${NC}'  to suspend the virtual machine"
echo -e "   Run '${GREEN}vagrant halt${NC}'     to stop the virtual machine"
echo -e "   Run '${GREEN}sshguest${NC}'        to login into the virtual machine"
echo
