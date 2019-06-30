#!/bin/sh

# alpine setup
sudo echo 'default_kernel_opts="quiet rootfstype=ext4 cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1"' >> /etc/update-extlinux.conf 
sudo update-extlinux
sudo echo "127.0.0.1    localhost localhost.localdomain" >> /etc/hosts

# k3s setup
sudo mv /tmp/k3s / 
sudo chmod +x /k3s/*
sudo mv /k3s/k3s /usr/local/bin/

exit 0
