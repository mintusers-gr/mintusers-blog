# -*- mode: ruby -*-
# vi: set ft=ruby :

IP = '192.168.10.50'
HOSTNAME = 'local.mintusers.me'

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true


  config.vm.provider :virtualbox do |vb, override|
    host = RbConfig::CONFIG["host_os"]
    if host  =~ /linux/
      memory = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024
      #vb.memory = memory / 4
      vb.memory = 1024
      vb.cpus = `nproc`.to_i
    end
  end


  config.vm.define 'blog' do |machine|
    machine.vm.hostname = HOSTNAME
    machine.vm.network 'forwarded_port', :guest => 5678, :host => 5678, :auto_correct => true  # for livereload
    machine.vm.network 'forwarded_port', :guest => 4000, :host => 4000, :auto_correct => true  # for Jekyll
    machine.vm.network 'forwarded_port', :guest => 5000, :host => 5000, :auto_correct => true  # for yard documentation

    machine.vm.box = 'ubuntu/trusty64'
    machine.vm.box_check_update = false

    # NFS require private networking
    machine.vm.network 'private_network', ip: IP
    machine.vm.synced_folder 'blog', '/blog', :type => 'nfs'

    machine.hostmanager.aliases = [ HOSTNAME ]
  end

  config.vm.provision :shell, :path => "scripts/provision.sh", keep_color: true

end