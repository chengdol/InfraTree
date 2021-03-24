#!/bin/bash
set -euo pipefail
set -x

ES_VERSION="7.11.1"
ES_CLUSTER_NAME="chengdol-es"
ES_HOME="/opt/elasticsearch-${ES_VERSION}"

KIBANA_VERSION="7.11.2-linux-x86_64"
KIBANA_SERVER_NAME="chengdol-kibana"
KIBANA_HOME="/opt/kibana-${KIBANA_VERSION}"


# stop firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld
# use self-contained jdk
#sudo yum install -y -q java-1.8.0-openjdk-devel


# system settings for elasticsearch
# disable swapping
SWAP_CONFIG=$(grep swap /etc/fstab)
sudo sed -i -e "/swap/c#${SWAP_CONFIG}" /etc/fstab
sudo swapoff -a

# for testing purpose, belows may not necessarily need:
# increase file descriptor
echo "elastic  -  nofile  65535" | sudo tee -a /etc/security/limits.conf
# make sufficient virtual memory 
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -w vm.max_map_count=262144
# ensure sufficient threads
echo "elastic  -  nproc 4096" | sudo tee -a /etc/security/limits.conf
# add elastic user and group
# cannot launch es as root
sudo groupadd elastic
sudo useradd elastic -g elastic

# install elasticsearch
sudo curl -s -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz
sudo /bin/cp -rf ./elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz ${ES_HOME}-linux-x86_64.tar.gz
sudo tar -C /opt -xf ${ES_HOME}-linux-x86_64.tar.gz
sudo chown -R elastic:elastic ${ES_HOME}


# elasticsearch configuration
sudo mkdir -p /var/data/elasticsearch
sudo mkdir -p /var/log/elasticsearch
sudo chown -R elastic:elastic /var/data/elasticsearch
sudo chown -R elastic:elastic /var/log/elasticsearch

# config custom parameters
cat << _EOF_  | sudo tee -a ${ES_HOME}/config/elasticsearch.yml
cluster.name: ${ES_CLUSTER_NAME}
node.name: ${HOSTNAME}

network.host: _eth1_
http.port: 9200

path:
  data: /var/data/elasticsearch
  logs: /var/log/elasticsearch

discovery.seed_hosts:
  - 172.20.21.30:9300
  - 172.20.21.31:9300
cluster.initial_master_nodes:
  - 172.20.21.30
_EOF_


if [[ "$HOSTNAME" == "master" ]]; then
  cat << _EOF_ | sudo tee -a ${ES_HOME}/config/elasticsearch.yml
node.roles: [ master ]
_EOF_
else
  cat << _EOF_ | sudo tee -a ${ES_HOME}/config/elasticsearch.yml
node.roles: [ data ]
_EOF_
fi

# run ES as daemon
# Log messages can be found in the $ES_HOME/logs/ directory
sudo su - elastic -c "export ES_HOME=${ES_HOME}; ${ES_HOME}/bin/elasticsearch -d -p pid"
# pkill -F pid (pid is the file contains PID)
sleep 2


# install and run kibana on master
# access kibana dashboard from http://172.20.21.30:5601
if [[ "$HOSTNAME" == "master" ]]; then
  cd /opt
  sudo curl -s -O https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}.tar.gz
  sudo tar -xzf kibana-${KIBANA_VERSION}.tar.gz 

  sudo groupadd kibana
  sudo useradd kibana -g kibana

  sudo mkdir -p ${KIBANA_HOME}/log
  sudo chown -R kibana:kibana ${KIBANA_HOME}

  cat << _EOF_ | sudo tee -a ${KIBANA_HOME}/config/kibana.yml
server.port: 5601
server.host: "172.20.21.30"

server.name: "${KIBANA_SERVER_NAME}"
elasticsearch.hosts: ["http://172.20.21.30:9200", "http://172.20.21.31:9200"]

pid.file: ${KIBANA_HOME}/kibana.pid
kibana.index: ".kibana"
_EOF_
 
  sudo su - kibana -c "export KIBANA_HOME=${KIBANA_HOME}; ${KIBANA_HOME}/bin/kibana &>${KIBANA_HOME}/log/$(date +'%Y-%m-%d-%H-%M-%S').log  &"
  sleep 2
fi

