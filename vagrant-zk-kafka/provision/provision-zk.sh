#!/bin/bash
set -eux

# enable extglob for extended pattern matching
shopt -s extglob

ZK_URL=$1
ZK_TGZ=${ZK_URL##*\/}
ZK_DIR=${ZK_TGZ%@(.tgz|.tar.gz)}

# zk and kafka id are extracted from hostname digit suffix
ZK_ID=${HOSTNAME##*[:alpha:]}

## stop firewalld
systemctl stop firewalld
systemctl disable firewalld

# ensure current dir is root home
cd
echo "whoami: " $(whoami)
echo "pwd: " $(pwd)

# install Java 8
yum install -q -y java-1.8.0-openjdk-devel
java -version

# zookeeper setup
wget --no-verbose $ZK_URL
tar -zxf $ZK_TGZ
/bin/cp /provision/zoo.cfg ./$ZK_DIR/conf/zoo.cfg

mkdir -p ./zk/data
mkdir -p ./zk/log
mkdir -p ./zk/conf

echo $ZK_ID > ./zk/data/myid
./$ZK_DIR/bin/zkServer.sh start
