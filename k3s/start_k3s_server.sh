#!/bin/sh

secret='123secret'
bind_address="$1"

sudo k3s server --bind-address $bind_address --disable-agent --cluster-secret $secret --no-deploy traefik
