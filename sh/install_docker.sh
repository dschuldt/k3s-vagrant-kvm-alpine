#!/bin/sh

sudo apk add docker
sudo rc-update add docker boot
sudo service docker start
sudo addgroup vagrant docker

echo "Docker setup finished successfully"
exit 0