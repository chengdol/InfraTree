## Minimal Elasticsearch Cluster

> Update: Since I am now on Mac M2 chip, so the VM image is switched to rocky
linux arm64, as the result the ES stack binary is updated to arm64 version.

This is a simple elasticsearch 3-node cluster for demo purpose.

It contains components such as Elasticsearch, Filebeat, Logstash and Kibana, all
installed by downloading binary and run (no systemd use):

- master node: ES master, Kibana
- data1 node:  ES data
- client node: Filebeat, Logstash

On client node, Filebeat collects sample data from a Apache log file and passes
it to Logstash which runs in the same node. Then Logstash performs some filterings
and then pass result onto ES cluster and store data there.

Bring up 3 nodes, ES data node suffix index starts from `1`:
```bash
vagrant up

# or separately in order
vagrant up data1
vagrant up master
# vagrant up data1 master
vagrant up client

# check status
vagrant status
```
SSH to each node:
```bash
vagrant ssh [master]
vagrant ssh data1
vagrant ssh client
```
Destroy VMs:
```bash
vagrant destroy -f
```

You ssh to VM and chech ps to see if the binary is running, for example:
```bash
ps aux | grep elasticsearch
ps aux | grep -E "filebeat|logstash"
```

To access Kibana, go to incognito chrome browser:
```
http://172.20.21.30:5601
```

Try API calls in Kibana dev console:
```bash
# check node status
GET /_cat/nodes?v&pretty&format=json
# check index
GET /_cat/indices?v

# query sample data
# <DATE> is replaced by real value
GET /apache-stale-log-<DATE>/_search?pretty&q=response=200
GET /apache-stale-log-<DATE>/_search?pretty&q=geoip.city_name=Buffalo
```

To query and analyze the sample data in Kibana, you need to create the Index
pattern first and use it in discovery.
