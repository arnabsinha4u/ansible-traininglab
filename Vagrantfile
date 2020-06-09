# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.ssh.insert_key = false
  config.vm.provider "virtualbox"
  config.ssh.forward_agent = true
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.define "traininglab", primary: true do |my_vm|
    my_vm.vm.box = "redesign/centos7"
    my_vm.vm.synced_folder ".", "/vagrant", disabled: false
    #my_vm.vm.synced_folder ".", "/vagrant", type: "nfs"
    my_vm.vm.network "private_network", ip: "192.168.177.74", :netmask => "255.255.255.0",  auto_config: true
    my_vm.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2274, auto_correct: false
    my_vm.vm.provider :virtualbox do |vb|
      vb.customize [
          "modifyvm", :id,
          "--name", "traininglab",
      ]
    end
    my_vm.vm.provider :vmware_desktop do |vmware|
       vmware.vmx["ethernet0.pcislotnumber"] = "33"
    end
    my_vm.vm.provision "ansible_local" do |ansible|
      ansible.compatibility_mode = "2.0"
#      ansible.galaxy_role_file = "/vagrant/ansible/roles/requirements.yml"
#      ansible.galaxy_roles_path = "/vagrant/ansible/galaxy_roles"
      ansible.playbook = "/vagrant/ansible_lab.yml"
      ansible.tags = "baseline,m_startup"
      ansible.become = true
      ansible.verbose = "vv"
    end
  end
end
