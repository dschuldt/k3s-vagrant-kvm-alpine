#!/bin/sh

check="/home/vagrant/postinstall_success"

if [ ! -f "$check" ]; then
  # set permissions on kubeconfig for later scp
  while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do
    sleep 5
  done
  sudo chmod 0777 /etc/rancher/k3s/k3s.yaml
  touch "$check"
fi

exit 0
