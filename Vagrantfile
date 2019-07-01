# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

unless Vagrant.has_plugin?("vagrant-alpine")
  raise 'vagrant-alpine plugin is required'
end

unless Vagrant.has_plugin?("vagrant-reload")
  raise 'vagrant-reload plugin is required'
end

options = YAML.load_file('config.yml')
puts "Config: #{options.inspect}\n\n"

Vagrant.configure("2") do |config|
  
  # --- SERVER ---
  config.vm.define "k3sserver" do |server|
    server.vm.box = options.fetch('vagrantbox')
    server.vm.network "private_network", ip: options.fetch('network') +'100'
    server.vm.hostname = options.fetch('server').fetch('hostname')
    server.vm.provider "libvirt" do |libvirt, override|
      libvirt.cpus = options.fetch('server').fetch('cpu')
      libvirt.memory = options.fetch('server').fetch('ram')
      libvirt.driver = "kvm"
      override.vm.guest = options.fetch('vmguest')
      libvirt.channel :type => 'unix', :target_name => 'org.qemu.guest_agent.0', :target_type => 'virtio'
    end
    server.vm.provision "shell", path: "k3s/install_docker.sh"
    server.vm.provision "file", source: "k3s/", destination: "/tmp/"
    server.vm.provision "shell", path: "k3s/prepare.sh"
    server.vm.provision "file", source: "manifests", destination: "/var/lib/rancher/k3s/server/"
    server.vm.provision :reload
    server.trigger.after :up do |trigger|
      trigger.name = "k3s_server_start"
      trigger.info = "start k3s server"
      trigger.run_remote = {inline: "nohup /k3s/start_k3s_server.sh " + options.fetch('network') + '100' + " 0<&- &> /k3s/k3s.log &"}
    end
    server.trigger.after :up do |trigger|
      trigger.name = "print_kubeconfig"
      trigger.info = "print kubeconfig"
      trigger.run_remote = {inline: "sleep 15s; sudo chmod 0777 /etc/rancher/k3s/k3s.yaml; sudo cat /etc/rancher/k3s/k3s.yaml"}
    end
    server.trigger.after :up do |trigger|
      trigger.name = "download_kubeconfig"
      trigger.info = "download kubeconfig"
      trigger.run = {inline: "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i .vagrant/machines/k3sserver/libvirt/private_key -q vagrant@" +options.fetch('network') + '100'":/etc/rancher/k3s/k3s.yaml ./config"}
    end      
  end

  # --- AGENTS ---
  (1..options.fetch('agent').fetch('count')).each do |i|
    config.vm.define "k3sagent#{i}" do |agent|
      agent.vm.box = options.fetch('vagrantbox')
      agent.vm.network "private_network", ip: options.fetch('network') + "10#{i}"
      agent.vm.hostname = options.fetch('agent').fetch('hostname') + "0#{i}"
      agent.vm.provider "libvirt" do |libvirt, override|
        libvirt.cpus = options.fetch('agent').fetch('cpu')
        libvirt.memory = options.fetch('agent').fetch('ram')
        libvirt.driver = "kvm"
        override.vm.guest = options.fetch('vmguest')
        libvirt.channel :type => 'unix', :target_name => 'org.qemu.guest_agent.0', :target_type => 'virtio'
      end
      agent.vm.provision "shell", path: "k3s/install_docker.sh"
      agent.vm.provision "file", source: "k3s/", destination: "/tmp/"
      agent.vm.provision "shell", path: "k3s/prepare.sh"
      agent.vm.provision :reload
      agent.trigger.after :up do |trigger|
        trigger.name = "k3s_agent_start"
        trigger.info = "start k3s agent"
        trigger.run_remote = {inline: "nohup /k3s/start_k3s_agent.sh https://" + options.fetch('network') + '100:6443' + " 0<&- &> /k3s/k3s.log &"}
      end  
    end
  end

end
