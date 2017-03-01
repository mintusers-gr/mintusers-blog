# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Manage config using the .env file
  config.env.enable # enable the plugin
  BOX_IP = ENV['BOX_IP'] || '192.168.10.70'
  BOX_NAME = ENV['BOX_NAME'] || 'jekyll'
  BOX_HOSTNAME = ENV['BOX_HOSTNAME'] || 'jekyll.mintusers.me'
  max_memory = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024
  BOX_MEM = ENV['BOX_MEM'] || max_memory / 4

  # Manage /etc/hosts file
  config.hostmanager do |h|
    h.enabled = true
    h.manage_host = true
    h.manage_guest = true
    h.ignore_private_ip = false
    h.include_offline = false
  end


  config.vm.provider :virtualbox do |vb, override|
    host = RbConfig::CONFIG["host_os"]
    if host  =~ /linux/
      vb.memory = BOX_MEM
      vb.cpus = ENV['BOX_CPU'] || `nproc`.to_i
    end
  end

  config.vm.define BOX_NAME do |machine|
    machine.vm.hostname = BOX_NAME
    machine.vm.network 'forwarded_port', :guest => 5678, :host => 5678, :auto_correct => true  # for livereload
    machine.vm.network 'forwarded_port', :guest => 4000, :host => 4000, :auto_correct => true  # for Jekyll
    machine.vm.network 'forwarded_port', :guest => 5000, :host => 5000, :auto_correct => true  # for yard documentation

    machine.vm.box = 'ubuntu/trusty64'
    machine.vm.box_check_update = false

    machine.vm.network 'private_network', ip: BOX_IP
    machine.hostmanager.aliases = [ BOX_HOSTNAME ]
  end

  config.vm.provision "file", source: "/usr/local/bin/hub", destination: "hub"
  config.vm.provision :shell, path: "bin/machine_provision.sh", keep_color: true

  # So you can use your private keys inside the box
  config.ssh.forward_agent = true
  # So you can run firefox
  config.ssh.forward_x11 = true
end
