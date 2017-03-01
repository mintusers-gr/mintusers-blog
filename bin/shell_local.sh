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
export PATH="/vagrant/jekyll-blog/bin:/vagrant/bin:$PATH"

# Use hub and not git
eval "$(hub alias -s)"

unalias ag 2>/dev/null
alias yard-server="yard server --gems --port 5000 --bind 0.0.0.0"

cd /vagrant
printInfo "Ready!"
echo

