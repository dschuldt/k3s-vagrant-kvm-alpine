#!/bin/sh

check="/home/vagrant/tiller_success"

if [ ! -f "$check" ]; then
  # install tiller
  helm init --service-account tiller --history-max 200 --kubeconfig /etc/rancher/k3s/k3s.yaml
  while [ "$(k3s kubectl get po -n kube-system | grep tiller | grep Running | awk '{print $3}')" != 'Running' ]; do
    sleep 5
  done
  touch "$check"
fi

exit 0
