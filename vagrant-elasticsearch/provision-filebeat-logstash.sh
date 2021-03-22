#!/bin/bash
set -euf pipefail
set -x

FILEBEAT_VERSION="filebeat-7.11.2-linux-x86_64"
LOGSTASH_VERSION="logstash-7.11.2"

cd /opt
# download sample data file with apache log
sudo curl -s -L -O https://download.elastic.co/demos/logstash/gettingstarted/logstash-tutorial.log.gz
sudo gzip -d logstash-tutorial.log.gz

# filebeat
sudo curl -s -L -O https://artifacts.elastic.co/downloads/beats/filebeat/${FILEBEAT_VERSION}.tar.gz
sudo tar -xzf ${FILEBEAT_VERSION}.tar.gz
# user and group
sudo groupadd filebeat
sudo useradd filebeat -g filebeat
sudo chown -R filebeat:filebeat ./${FILEBEAT_VERSION}

cat << _EOF_ | sudo tee /opt/${FILEBEAT_VERSION}/filebeat.yml
# read log from log file, the log file contains Apache server log data
filebeat.inputs:
- type: log
  paths:
    - /opt/logstash-tutorial.log

# send beat data to logstash
# the logstash is running on the same machine with port 5044 to receive data
output.logstash:
  hosts: ["localhost:5044"]
_EOF_
# start filebeat
sudo su - filebeat -c "cd /opt/${FILEBEAT_VERSION}; ./filebeat -c filebeat.yml -d 'publish' &"


# logstash
sudo curl -s -L -O https://artifacts.elastic.co/downloads/logstash/${LOGSTASH_VERSION}-linux-x86_64.tar.gz
sudo tar -zxf ${LOGSTASH_VERSION}-linux-x86_64.tar.gz 
sudo groupadd logstash
sudo useradd logstash -g logstash

sudo touch /opt/${LOGSTASH_VERSION}/first-pipeline.conf
sudo chown -R logstash:logstash /opt/${LOGSTASH_VERSION}

cat << _EOF_ | sudo tee /opt/${LOGSTASH_VERSION}/first-pipeline.conf
# The # character at the beginning of a line indicates a comment. Use
# comments to describe your configuration.

# read from port 5044 which is used by filebeat
input {
    beats {
        port => "5044"
    }
}
# filter is executed in sequence from top to bottom
filter {
    # grok breakdown and parse the Apache server log
    grok {
        match => { "message" => "%{COMBINEDAPACHELOG}"}
    }
    # extract geo detail from ip
    # clientip is generated from grok
    geoip {
        source => "clientip"
    }
}
# indexing data into elasticsearch
# here are the master and data node ip
output {
    # default index name is logstash-%{+YYYY.MM.dd}
    elasticsearch {
      hosts => [ "172.20.21.30:9200", "172.20.21.31:9200" ]
      index => "apache-stale-log-%{+YYYY.MM.dd}"
    }
}
_EOF_
# start logstash
sudo su - logstash -c "cd /opt/${LOGSTASH_VERSION}; bin/logstash -f first-pipeline.conf --config.reload.automatic &> /dev/null &"

