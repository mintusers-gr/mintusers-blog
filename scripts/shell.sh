#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

source /vagrant/.env
if [[ ! $JEKYLL_GITHUB_TOKEN ]]
then
    echo -e "\n\n${RED}Error: JEKYLL_GITHUB_TOKEN is empty.${NC}"
    echo -e "Create an .env file and put it there.\n\n"
fi

printf "${GREN}Ready to serve.${NC}\n"
printf "   type jserv to start server\n\n"

alias jserv='/vagrant/scripts/jekyll_server.sh'
cd /vagrant/blog