#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

printf "${GREN}Ready to serve.${NC}\n"
printf "   type jserv to start server\n\n"

alias jserv='/vagrant/scripts/server.sh'
cd /blog