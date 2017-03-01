#!/bin/bash -e

# This contains code from :
#   https://github.com/gdbtek/linux-cookbooks/blob/master/libraries/util.bash
#   http://serverfault.com/questions/20747/find-last-time-update-was-performed-with-apt-get

function printInfo() {
    local -r message="${1}"

    echo -e "\033[1;36m${message}\033[0m" 2>&1
}

function printDebug()
{
    local -r message="${1}"

    echo -e "\033[1;34m${message}\033[0m" 2>&1
}

function trimString()
{
    local -r string="${1}"

    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

function isEmptyString()
{
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true'
    else
        echo 'false'
    fi
}

function escapeGrepSearchPattern()
{
    local -r searchPattern="${1}"

    # shellcheck disable=SC2016
    sed 's/[]\.|$(){}?+*^]/\\&/g' <<< "${searchPattern}"
}

function getLastAptGetUpdate()
{
    local aptDate="$(stat -c %Y '/var/cache/apt')"
    local nowDate="$(date +'%s')"

    echo $((nowDate - aptDate))
}

function runAptGetUpdate()
{
    local updateInterval="${1}"

    local lastAptGetUpdate="$(getLastAptGetUpdate)"

    if [[ "$(isEmptyString "${updateInterval}")" = 'true' ]]
    then
        # Default To 24 hours
        updateInterval="$((24 * 60 * 60))"
    fi

    if [[ "${lastAptGetUpdate}" -gt "${updateInterval}" ]]
    then
        printInfo "** Running 'apt-get update'"
        apt-get update -m
    else
        local lastUpdate="$(date -u -d @"${lastAptGetUpdate}" +'%-Hh %-Mm %-Ss')"

        printInfo "** Skip apt-get update because its last run was '${lastUpdate}' ago"
    fi
}

function isAptGetPackageInstall()
{
    local -r package="$(escapeGrepSearchPattern "${1}")"
    local -r found="$(dpkg --get-selections | grep -E -o "^${package}(:amd64)*\s+install$")"

    if [[ "$(isEmptyString "${found}")" = 'true' ]]
    then
        echo 'false'
    else
        echo 'true'
    fi
}

function installAptGetPackage()
{
    local -r package="${1}"

    if [[ "$(isAptGetPackageInstall "${package}")" = 'true' ]]
    then
        printInfo "** Apt-Get Package '${package}' has already been installed"
    else
        echo -e "\033[1;35m** Installing Apt-Get Package '${package}'\033[0m"
        DEBIAN_FRONTEND='noninteractive' apt-get install -qq "${package}" --fix-missing -y > /dev/null
    fi
}


function installVagrantPlugin()
{
    local -r package="${1}"
    if vagrant plugin list | grep -q "${package}"
    then
      printInfo "** Vagrant plugin '${package}' has already been installed"
    else
      printInfo "** Installing agrant plugin '${package}'"
      vagrant plugin install "${package}"
    fi
}

function geminstall()
{
    local -r gem_install=`gem list $1 -i`
    if [ "$gem_install" == "false" ]; then
        printInfo "** Installing ${1} gem."
        gem install $1 --no-ri --no-rdoc
    else
        printInfo "** Gem ${1} is allready installed."
    fi
}

function goto_repo_root()
{
  local -r gitroot=$(git rev-parse --show-cdup)
  if [ "$gitroot" != "" ]
  then
    if [ "$gitroot" != "$HOME" ]
    then
      cd "$gitroot"
     else
      echo "Aeems the git root is at your home directory."
     fi
   else
    if [ ! -d .git ]
    then
      echo "Not inside a git repository"
    fi
   fi
}
