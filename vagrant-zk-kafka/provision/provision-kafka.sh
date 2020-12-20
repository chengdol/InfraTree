#!/bin/bash
set -eux

# enable extglob for extended pattern matching
shopt -s extglob

KAFKA_URL=$1
KAFKA_TGZ=${KAFKA_URL##*\/}
KAFKA_DIR=${KAFKA_TGZ%@(.tgz|.tar.gz)}

# zk and kafka id are extracted from hostname digit suffix
KAFKA_ID=${HOSTNAME##*([[:alpha:]])}

# host ip address
[[ $(hostname -I) =~ 192.168\..{2}\..{2} ]]
HOST_IP=${BASH_REMATCH}

## stop firewalld
systemctl stop firewalld
systemctl disable firewalld

# ensure current dir is root home
cd
echo "whoami: " $(whoami)
echo "pwd: " $(pwd)

# kafka setup
wget --no-verbose $KAFKA_URL
tar -zxf $KAFKA_TGZ
/bin/cp /provision/server.properties ./$KAFKA_DIR/config/server.properties

mkdir -p ./kafka/log
sed -i -e "s#KAFKA_ID#${KAFKA_ID}#g" -e "s#HOST_IP#${HOST_IP}#g" ./$KAFKA_DIR/config/server.properties

./$KAFKA_DIR/bin/kafka-server-start.sh -daemon ./$KAFKA_DIR/config/server.properties
