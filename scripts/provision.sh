#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

apt-get -y install python-software-properties
apt-add-repository -y ppa:brightbox/ruby-ng

# apt-get -y update
# Here's a simple one-liner to run an update if it hasn't been run in the last day.
(find /var/lib/apt/periodic/update-success-stamp -mtime +1 | grep update-success-stamp) && (/usr/bin/apt-get update)

#install ruby with build tools so we can use gems
apt-get -y install \
    build-essential \
    ruby2.4 \
    ruby2.4-dev \
    liblzma-dev \
    zlib1g-dev \
    nodejs \
    language-pack-el \
    nginx \
    git

apt-get -y autoremove

#install github pages requirements (jekyll)
geminstall () {
    install =`gem list $1 -i`
    if ["$install" == "false"]; then
        echo -e "**** Installing ${GREEN}${1}${NC} gem."
        gem install $1 --no-ri --no-rdoc
    fi
}

gem update --system
geminstall bundler
geminstall nokogiri
geminstall jekyll
geminstall github-pages
geminstall redcarpet
geminstall yard

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

cp /vagrant/scripts/nginx.site /etc/nginx/sites-available/default
service nginx restart

cp /vagrant/scripts/jekyll_service /etc/init.d/jekyll_service
chmod +x /etc/init.d/jekyll_service
update-rc.d jekyll_service defaults
service jekyll_service start

cp /vagrant/scripts/yard_service /etc/init.d/yard_service
chmod +x /etc/init.d/yard_service
update-rc.d yard_service defaults
service yard_service start

echo -e "**** Installing local application gem."
cd /vagrant/blog
sudo -u vagrant bundle install
bundle show
echo -e "${GREEN}**** ALL DONE *** ${NC}\n\n"