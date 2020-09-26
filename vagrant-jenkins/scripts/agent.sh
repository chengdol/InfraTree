#!/bin/bash
# Put provisioning stuff here

## append id_rsa.pub to authorized_keys
cat /vagrant/id_rsa.pub >> ~/.ssh/authorized_keys

## install required packages
sudo yum install -y java-1.8.0-openjdk-devel
