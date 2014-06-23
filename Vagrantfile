
# Instructions:
#
# This is a purposely broken LAMP instance.  Your goal is to fix as many issues as possible.  You should receive a welcome message on the forwarded HTTP port when successful.  
#
# Points will be awarded for both fixing the issue and the method used.  Puppet, Chef, or Ansible should be used if possible.
# 
# Issues:
# 1. There are at least 1 OS issue
# 2. There are at least 1 security issue
# 3. There are at least 2 Apache issues
# 4. There are at least 3 MySQL issues
#
#
# ssh credentials: root/broken
# mysql credentials: root/broken

# One thing that must be done is to fix the missing scp file. Login to the box and issue the command:
# yum install openssh-clients
# logut
# vagrant reload --provision

###
# Variables for vm
###
box      = 'test3'
hostname = 'broken'
domain   = 'localhost.localdomain'
url      = 'https://s3.amazonaws.com/LinuxEngineer-Test/BrokenBox.box'

###
# Provision shell
###
$script = <<SCRIPT
/etc/init.d/iptables stop
yum -y install openssh-clients
date >> /etc/vagrant_provisioned_at
SCRIPT

### 
# Start Vagrant config
###
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # set box
  config.vm.box = box
  # set hostname
  config.vm.host_name = hostname + '.' + domain
  # set url to pull system iso
  config.vm.box_url = url

  #config.ssh.username = "root"
  #config.ssh.password = "broken"
  #config.ssh.pty = true

  # run some shell commands once openssh-clients is installed
  config.vm.provision "shell", inline: $script

  config.vm.network 'forwarded_port', guest: 80, host: 8080
      
  config.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'puppet/manifests'
      #puppet.manifest_file = 'site.pp'
      puppet.module_path = 'puppet/modules'
  end
  

  config.vm.provider "virtualbox" do |v|
      v.gui = true
  end
 end


# -*- mode: ruby -*-
# vi: set ft=ruby :
