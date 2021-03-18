#!/bin/bash
set -euo pipefail
set -x

ES_VERSION="7.11.1"
ES_CLUSTER_NAME="chengdol-es"
ES_HOME="/opt/elasticsearch-${ES_VERSION}"

# stop firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld
# install required packages
sudo yum install -y -q java-1.8.0-openjdk-devel


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

# run as daemon
# Log messages can be found in the $ES_HOME/logs/ directory
sudo su - elastic -c "export ES_HOME=${ES_HOME}; /opt/elasticsearch-${ES_VERSION}/bin/elasticsearch -d -p pid"
# pkill -F pid (pid is the file contains PID)

#sleep 30
#sudo curl -X GET "172.20.21.30:9200/_cat/health?v=true&format=json&pretty"
