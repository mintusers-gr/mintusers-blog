#!/usr/bin/env bash

if [ -d /vagrant ]
then
  source "/vagrant/bin/utils.bash"
  printInfo "*************************************************"
  printInfo "* Don't run this on the guest machine please!   *"
  printInfo "*************************************************"
  exit
else
  source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"
fi

BOX_FILE="vagrant-jekyll-v0.1"

goto_repo_root
mkdir -p .boxes

if [ ! -f .boxes/${BOX_FILE} ]
then
  printInfo "### Creating a vagrant box ###"
  printInfo "### This will take alot of time ...."
  vagrant package --output .boxes/${BOX_FILE}
  printInfo "Done"

  echo ""
  echo "To register the new box type:"
  echo "  vagrant box add ${BOX_FILE} ${BOX_FILE}.box"
  echo "To restart the new box type:"
  echo "  vagrant up"
else
  printInfo "The box ${BOX_FILE} already exists."
  echo -e "Delete that file and optionaly update version first."
  echo -e "type: rm .boxes/${BOX_FILE}.box\n"
fi
