#!/usr/bin/env bash

apt-get -y install python-software-properties
apt-add-repository -y ppa:brightbox/ruby-ng
apt-get -y update

#install ruby with build tools so we can use gems
apt-get -y install \
    build-essential \
    ruby2.1 \
    ruby2.1-dev \
    liblzma-dev \
    zlib1g-dev \
    nodejs \
    language-pack-el \
    nginx
apt-get -y autoremove

#install github pages requirements (jekyll)
gem update --system
gem install bundler --no-ri --no-rdoc
gem install github-pages --no-ri --no-rdoc
gem install redcarpet --no-ri --no-rdoc

if grep -q shell.sh /home/vagrant/.bashrc
then
    echo "shellrc is allready loaded"
else
    echo "source /vagrant/scripts/shell.sh" >>  /home/vagrant/.bashrc
    echo "shellrc loaded"
fi

file="/vagrant/.env"
if [ -f "$file" ]
then
    cp /vagrant/.env ~/.env
else
    echo -e "\033[0;31mERROR: Please create an .env file holding your secrets\033[0m"
fi

chown -R vagrant /var/www
cd /blog
bundle install