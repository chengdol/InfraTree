## Simple Elasticsearch Cluster

This is a simple production elasticsearch 2-node cluster for demonstration purpose.
It will set Kibana and Logstash componetns.

To access Kibana dashboard, try:
```
http://172.20.21.30:5601
```

Bring up master and data node(suffix index starts from 1)
```bash
vagrant up

# or separately
vagrant up master
vagrant up data1

# check status
vagrant status
```
SSH to master/data:
```bash
vagrant ssh [master]
vagrant ssh data1
```
Destroy VMs:
```bash
vagrant destroy -f
```

To add more data nodes, increase loop range in data nodes block: 
```ruby
  # data nodes
  # for example (1..2)
  (1..1).each do |i|
    config.vm.define "data#{i}" do |v|
      v.vm.hostname = "date#{i}"
      v.vm.network "private_network", ip: "172.20.21.3#{i}"
    end
  end
```
And append data nodes IP:9300 in provision.sh file: 
```yaml
discovery.seed_hosts:
  - 172.20.21.30:9300
  - 172.20.21.31:9300
  - append here
```
