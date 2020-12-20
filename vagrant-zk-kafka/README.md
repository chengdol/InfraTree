# Zookeeper-Kafka 3 Node Cluster Setup
This is a demo to bring up a multi-node cluster for Kafka alongsides Zookeeper.

As explained in Vagrantfile, using static ip for each node:
```bash
IP1 = "192.168.20.20"
IP2 = "192.168.20.21"
IP3 = "192.168.20.22"
```
You can adjust them accordingly, but make sure they can access each other.

If needed, update the Zookeeper and Kafka download link in `shell-playbook.sh`:
```bash
ZK_URL = "https://archive.apache.org/dist/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz"
KAFKA_URL= "https://mirrors.sonic.net/apache/kafka/2.6.0/kafka_2.12-2.6.0.tgz"
```

The provisioning shell will automatically config and start the zookeeper and kafka. To speed up processing, SSH commands run parallelly.
An alternative is to use Ansible.

After playbook is done, ssh to any node to play with Kafka.
