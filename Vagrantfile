# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

NUM_MANAGED_NODE = 2
IP_NW = "192.168.30."
MANAGED_IP_START = 20

Vagrant.configure("2") do |config|
  
  config.vm.box = "centos/8"
  config.vm.box_check_update = false
  config.ssh.insert_key = false
  config.vm.synced_folder "./scenario", "/vagrant_data"

  # Provision ansible control Node
    
    config.vm.define "control" do |control|
      control.vm.hostname = "control.clevory.local"
	    control.vm.network :private_network, ip: "192.168.30.10"
	    control.vm.provision "shell", path: "control.sh"
      control.vm.provider "virtualbox" do |vb|
        vb.name = "control"
        vb.memory = "2048"
      end
	  end

  # Provision ansible managed Nodes
  
  (1..NUM_MANAGED_NODE).each do |i|  
	  config.vm.define "ansible0#{i}" do |node|
	    node.vm.hostname = "ansible0#{i}.clevory.local"
      node.vm.network :private_network, ip: IP_NW + "#{MANAGED_IP_START + i}"
	    node.vm.provision "shell", path: "managed.sh"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "ansible0#{i}"
        vb.memory = "2048"
      end                
    end
  end
end
