# k3s-vagrant-kvm-alpine

Bootstrap a Kubernetes cluster with [Rancher k3s](https://github.com/rancher/k3s), [KVM]([https://www.linux-kvm.org/page/Main_Page](https://www.linux-kvm.org/page/Main_Page)) and [Vagrant](https://www.vagrantup.com/) <del>in 90 seconds. (Ok, if you already have a local copy of the vagrant box; otherwise it depends on your download speed)</del>del>. I'm afraid this is not true any longer. But you get a tiller and istio installation with kiali as well :)

## Prerequisites
- A working qemu/kvm and vagrant setup
 - The following vagrant plugins:
   - vagrant-alpine
   - vagrant-reload

## Quickstart
1. Modify config.yml

<dl>
  <dt><strong>vagrantbox</strong></dt>
  <dd>The vagrant box the vms to be created are based on</dd>
  <dt><strong>network</strong></dt>
  <dd>Class C network to be used for vms (please note the trailing period; host ips will be appended automatically)</dd>
  <dt><strong>server/agent</strong></dt>
  <dd>Specify the k3s server and agent vms (please note that only the count of agents can be specified)</dd>
</dl>

2. Create the vagrant environment with
```sh
vagrant up --provider=libvirt
```
3. The kubeconfig file is printed in vagrant output (not very pretty though) or found in k3sserver vm at /etc/rancher/k3s/k3s.yaml.

## How does it work
- Vagrant spawns a vm for the k3s server as well as (multiple) vms for the k3s agents. 
- The k3s binary is copied to the vms in a vagrant provision stage.
- Several steps are necessary to prepare Alpine to make k3s work. Those steps are also executed in a provision stage and found in prepare.sh in the k3s directory. The vms are rebooted automatically afterwards.
- The k3s instances are started in a after-up trigger stage (scripts in k3s directory).