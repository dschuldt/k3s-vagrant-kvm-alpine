#!/bin/sh

# alpine setup
sudo echo 'default_kernel_opts="quiet rootfstype=ext4 cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1"' >> /etc/update-extlinux.conf 
sudo update-extlinux
sudo echo "127.0.0.1    localhost localhost.localdomain" >> /etc/hosts

# binary and directory setup 
sudo chmod +x /home/vagrant/sh/*
sudo mv /home/vagrant/sh/k3s /usr/local/bin/
sudo mv /home/vagrant/sh/helm /usr/local/bin/
sudo mkdir -p /var/lib/rancher/k3s/server/manifests/ && sudo chmod -R 0777 /var/lib/rancher/k3s/server/manifests/

exit 0
