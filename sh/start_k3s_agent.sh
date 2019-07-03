#!/bin/sh

secret='123secret'
server_url="$1"

sudo k3s agent --server $server_url --cluster-secret $secret
