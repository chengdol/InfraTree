#!/usr/bin/env bash
# Run this script after Vagrant process done
shopt -s extglob
#set -x
set -eu

#---------------- customize constants ----------------------
ZK_URL="https://archive.apache.org/dist/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz"
KAFKA_URL="https://mirrors.sonic.net/apache/kafka/2.6.0/kafka_2.12-2.6.0.tgz"
declare -a nodes=("zkkafka1" "zkkafka2" "zkkafka3")
#-----------------------------------------------------------

declare -a ports
declare -a keys

echo "Parse host SSH port and private key..."
for node in "${nodes[@]}"
do
  # --host flag has bug
  # have to display all ssh-config and extract
  port_line=$(vagrant ssh-config | grep -i -A 9 -E "Host ${node}" | grep "Port")
  key_line=$(vagrant ssh-config | grep -i -A 9 -E "Host ${node}" | grep "IdentityFile")
  port=$(echo ${port_line##*([[:blank:]])}| cut -d" " -f 2)
  key=$(echo ${key_line##*([[:blank:]])} | cut -d" " -f 2)

  ports+=($port)
  keys+=($key)
done

echo "Start on provisioning..."
# zookeeper setup
declare -a pids
for i in "${!nodes[@]}"
do
  echo "Node ${nodes[i]} target SSH port: ${ports[i]}"
  echo "Private key: ${keys[i]}"
  ssh -i ${keys[i]} \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -p ${ports[i]} \
    vagrant@127.0.0.1 "sudo bash /provision/provision-zk.sh ${ZK_URL}" &  

  pids+=($!)
done

wait ${pids[@]}
sleep 10
echo "Zookeeper setup done!"

# kafka setup
unset pids
for i in "${!nodes[@]}"
do
  echo "Node ${nodes[i]} target SSH port: ${ports[i]}"
  echo "Private key: ${keys[i]}"
  ssh -i ${keys[i]} \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -p ${ports[i]} \
    vagrant@127.0.0.1 "sudo bash /provision/provision-kafka.sh ${KAFKA_URL}" &

  pids+=($!)
done

wait ${pids[@]}
sleep 5

echo "Kafka setup done!"
