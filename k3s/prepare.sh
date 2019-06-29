#!/bin/sh

# alpine setup
sudo echo "cgroup /sys/fs/cgroup cgroup defaults 0 0" >> /etc/fstab
sudo cat >> /etc/cgconfig.conf <<EOF
mount {
cpuacct = /cgroup/cpuacct;
memory = /cgroup/memory;
devices = /cgroup/devices;
freezer = /cgroup/freezer;
net_cls = /cgroup/net_cls;
blkio = /cgroup/blkio;
cpuset = /cgroup/cpuset;
cpu = /cgroup/cpu;
}
EOF
sudo echo "default_kernel_opts=...  cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"  >> /etc/update-extlinux.conf 
sudo update-extlinux

# k3s setup
sudo mv /tmp/k3s / 
sudo chmod +x /k3s/*
sudo mv /k3s/k3s /usr/local/bin/

exit 0
