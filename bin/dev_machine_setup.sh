#!/bin/bash

if [ -d /vagrant ]
then
  source "/vagrant/bin/utils.bash"
  printInfo "*************************************************"
  printInfo "* Don't run this on the virtual machine please! *"
  printInfo "*************************************************"
  exit
else
  source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

goto_repo_root

# Look for a newer version here:
#    https://www.vagrantup.com/downloads.html
vagrant_file_url="https://releases.hashicorp.com/vagrant/1.9.1"
vagrant_file="vagrant_1.9.1_x86_64.deb"


source /etc/os-release
virtualbox_repo_line="deb http://download.virtualbox.org/virtualbox/debian ${UBUNTU_CODENAME} contrib"

## Do not change bellow this line if you don't know what you are doing ##
runAptGetUpdate "$((1 * 60 * 60))"
installAptGetPackage "dkms"
installAptGetPackage "wget"

# Install repository if not exist
repofile="/etc/apt/sources.list.d/virtualbox.list"
if [ ! -f "${repofile}" ]
then
  printInfo "** Installing VitrualBox repository"
  echo "${virtualbox_repo_line}" > ${repofile}
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
  apt-get update --ignore-missing

  installAptGetPackage "virtualbox-5.1"
  printInfo "** Downloading Extension Pack"
  version=$(vboxmanage -v)
  var1=$(echo $version | cut -d 'r' -f 1)
  var2=$(echo $version | cut -d 'r' -f 2)
  file="Oracle_VM_VirtualBox_Extension_Pack-$var1-$var2.vbox-extpack"
  echo -e "\033[1;35m** Downloading '${file}'\033[0m"
  wget  -c --quiet --show-progress http://download.virtualbox.org/virtualbox/$var1/$file -O /tmp/$file
  VBoxManage extpack uninstall "Oracle VM VirtualBox Extension Pack"
  VBoxManage extpack install /tmp/$file
else
  printInfo "** VitrualBox repository already exists"
  installAptGetPackage "virtualbox-5.1"
fi

#installAptGetPackage "vagrant"
if [[ "$(isAptGetPackageInstall "vagrant")" = 'true' ]]
then
    printInfo "** Vagrant has already been installed"
else
    echo -e "\033[1;35m** Downloading '${vagrant_file}'\033[0m"
    wget -P /tmp  -c --quiet --show-progress "${vagrant_file_url}/${vagrant_file}"
    DEBIAN_FRONTEND='noninteractive' dpkg -i "/tmp/${vagrant_file}"
    DEBIAN_FRONTEND='noninteractive' apt-get install --fix-missing -y
fi


installVagrantPlugin "vagrant-vbguest"
installVagrantPlugin "vagrant-hostmanager"
installVagrantPlugin "vagrant-env"

#TODO all users
if [ $SUDO_USER ]; then user=$SUDO_USER; else user=`whoami`; fi
suder_file="/etc/sudoers.d/vagrant_hostmanager"
if [ ! -f "${suder_file}" ]
then
  printInfo "** Fix sudo to enable editing of /etc/hosts without password (${suder_file})"
  echo "Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp /home/${user}/.vagrant.d/tmp/hosts.local /etc/hosts" > $suder_file
  echo "adm ALL=(root) NOPASSWD: VAGRANT_HOSTMANAGER_UPDATE" >> $suder_file
fi

hubfile_url="https://github.com/github/hub/releases/download/v2.3.0-pre9/hub-linux-amd64-2.3.0-pre9.tgz"
hubfile_file="hub-linux-amd64-2.3.0-pre9.tgz"
if [ ! -f /usr/local/bin/hub ]
then
  printInfo "** Installing hub tool"
  wget  -c --quiet --show-progress ${hubfile_url} -O /tmp/${hubfile_file}
  pushd /tmp
  tar xvfz hub-linux-amd64-2.3.0-pre9.tgz > /dev/null
  cd hub-linux-amd64-2.3.0-pre9
  ./install
  popd > /dev/null
else
  printInfo "** Hub tool is allready installed"
fi

printInfo "### INSTALLATION DONE ###"
echo ""
echo "Issue :"
echo "vagrant up"
echo "  to create and provision the virtual machine"
echo "vagrant ssh"
echo "  to login to your new machine"
echo ""
echo ""

#vagrant package --output vagrant-jekyll-ansible-v0.2.0.box
#vagrant box add vagrant-jekyll-ansible-v0.2.0 vagrant-jekyll-ansible-v0.2.0.box
