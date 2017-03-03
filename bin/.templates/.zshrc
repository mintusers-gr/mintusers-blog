#!/usr/bin/env bash
set -e

if [ ! -d /vagrant ]
then
  echo "$(tput setaf 1)*************************************************$(tput sgr0)"
  echo "$(tput setaf 1)* Don't run this on the host machine please!    *$(tput sgr0)"
  echo "$(tput setaf 1)*************************************************$(tput sgr0)"
  exit  1
fi

export PATH="/vagrant/jekyll-blog/bin:/vagrant/bin:$PATH"
source /vagrant/.env
check-jekyll-config
if [ ! -f /home/vagrant/.gitconfig ]
then
  git config --global user.email "${GIT_EMAIL}"
  git config --global user.name  "${GIT_NAME}"
  git config --global color.ui true
  git config --global push.default simple
  echo "$(tput setaf 3)~/.gitcongig file is created check it for sanity$(tput sgr0)"
fi


export ZSH=/home/vagrant/.oh-my-zsh
export EDITOR='vim'
export BROWSER='epiphany-browser'

ZSH_THEME="robbyrussell"
plugins=(git github ruby command-not-found gem rake-fast bundler dotenv)
source $ZSH/oh-my-zsh.sh

# Use hub and not git
eval "$(hub alias -s)"

# Some useful aliases
alias yard-server="yard server --gems --port 5000 --bind 0.0.0.0"
alias update-zshrc="cp /vagrant/bin/.templates/.zshrc /home/vagrant/.zshrc"
alias firefox='epiphany-browser'
alias blog-open="${BROWSER}  --profile /home/vagrant/.epiphany -a http://${BOX_HOSTNAME}:4000 >/dev/null 2>&1 &"

cd /vagrant/jekyll-blog
echo "\n$(tput setaf 6)Welcome to ${BOX_HOSTNAME}$(tput sgr0)"
echo "$(tput setaf 6)The webservice URL is http://${BOX_HOSTNAME}:4000$(tput sgr0)"
echo

# I believe its better to forgive errors in interactive mode :-)
mkdir -p "/home/vagrant/.epiphany"
set +e
