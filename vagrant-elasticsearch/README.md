## Simple Elasticsearch Cluster

This is a simple production elasticsearch 3-node cluster for demo purpose.

It contains components such as Elasticsearch, Filebeat, Logstash and Kibana, all
installed by downloading binary:
- master node: ES master, Kibana
- data1 node:  ES data
- client node: Filebeat, Logstash

On client node, Filebeat collects sample data from a Apache log file and passes
it to Logstash which runs in the same node. Then Logstash performs some filtering
jobs, handles result to ES cluster.

Bring up 3 nodes, ES data node suffix index starts from `1`:
```bash
vagrant up

# or separately
vagrant up data1
vagrant up master
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

To access Kibana dashboard, go to chrome browser:
```
http://172.20.21.30:5601
```
To query and analyze the sample data in Kibana, first set up Index Patterns.

Several requests in Kibana dev console:
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
