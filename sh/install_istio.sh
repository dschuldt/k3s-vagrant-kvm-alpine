#!/bin/sh

check="/home/vagrant/istio_success"

if [ ! -f "$check" ]; then
  # install istio-init
  sleep 10
  helm install /home/vagrant/istio-init --name istio-init --namespace istio-system --kubeconfig /etc/rancher/k3s/k3s.yaml
  # wait for crds to be created
  while [ "$(k3s kubectl get crd | grep istio | wc -l)" != 23 ]; do
    sleep 5
  done
  # install istio
  helm install /home/vagrant/istio --set kiali.enabled=true --name istio --namespace istio-system --kubeconfig /etc/rancher/k3s/k3s.yaml
  touch "$check"
fi

exit 0
