#!/bin/bash
set -eux
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
## use old version, containerd.io not yet update
sudo yum install -y docker-ce-18.09.0 docker-ce-cli-18.09.0 containerd.io

sudo systemctl enable docker
sudo systemctl start docker

## alias
sudo sh -c 'echo alias di=\"docker images\" >> /root/.bashrc'
sudo sh -c 'echo alias dp=\"docker ps\" >> /root/.bashrc'
sudo sh -c 'echo alias drp=\"docker rm -f\" >> /root/.bashrc'
sudo sh -c 'echo alias dri=\"docker rmi -f\" >> /root/.bashrc'
sudo sh -c 'echo alias dl=\"docker logs -f\" >> /root/.bashrc'
sudo tee -a /root/.bashrc << EOF
dexec()
{
  docker exec -it \${1} sh
}
EOF

## stop firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld
