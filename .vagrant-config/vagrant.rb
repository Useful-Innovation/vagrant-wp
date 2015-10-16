# -*- mode: ruby -*-

# Check that vagrant-hostsupdater is installed
if !Vagrant.has_plugin?("vagrant-hostsupdater")
  puts "Please run 'vagrant plugin install vagrant-hostsupdater' to install vagrant-hostsupdater"
  exit
end

# Set vhosts
vhosts = []
# Read dirs for vhost generation
dirs = Dir.glob('*').map {|f| if (File.directory? f) then f+'.dev' end} - [nil]
# Create array with dirs and www-prefixed dirs
dirs.each do |vh| vhosts << vh << 'www.' + vh end

# Create bash file with project variables
File.open("./.vagrant-config/config", 'w+') do |f|
  $project.each do |key, value|
    f.write("VAGRANT_" + key.upcase + "=" + value + "\n")
  end
end

Vagrant.configure(2) do |config|
  # Use trusty(Ubuntu Server 14.04 LTS)
  config.vm.box = "ubuntu/trusty64"

  # Set IP for this machine
  config.vm.network "private_network", ip: "192.168.33.100"

  # Set machine hostname
  config.vm.hostname = $project["project"]

  # Use hosts ssh agent
  config.ssh.forward_agent = true

  # Push dirs as aliases to hostsupdater
  config.hostsupdater.aliases = vhosts

  config.vm.synced_folder ".", "/home/vagrant/code/"
    #:mount_options => ["dmode=755", "fmode=755"]

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end

  # Provisioners

  # As root, on explicit provision
  config.vm.provision "shell",
    name: "root_provision",
    path: "./.vagrant-config/provisioners/root_provision.sh"

  # As root, always
  config.vm.provision "shell",
    name: "root_always",
    path: "./.vagrant-config/provisioners/root_always.sh",
    run:  "always"

  # As user, on explicit provision
  config.vm.provision "shell",
    name: "user_provision",
    path: "./.vagrant-config/provisioners/user_provision.sh",
    privileged: false

  # As user, always
  config.vm.provision "shell",
    name: "user_always",
    path: "./.vagrant-config/provisioners/user_always.sh",
    run:  "always",
    privileged: false

end