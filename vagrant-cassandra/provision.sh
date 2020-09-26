#!/bin/bash
# Put provisioning stuff here

## install required packages
sudo yum install -y java-1.8.0-openjdk-devel

## install cassandra
curl -OL https://downloads.apache.org/cassandra/3.11.6/apache-cassandra-3.11.6-bin.tar.gz
tar -xzf apache-cassandra-3.11.6-bin.tar.gz


## stop firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld


## switch vagrant ssh login as root 
#echo "sudo su -" >> /home/vagrant/.bashrc
