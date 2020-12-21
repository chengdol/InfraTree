#!/bin/bash
# Put provisioning stuff here
set -x

# append id_rsa.pub to authorized_keys
cd && mkdir -p ~/.ssh  && cat /vagrant/id_rsa.pub >> ~/.ssh/authorized_keys
# install required packages
yum install -q -y java-1.8.0-openjdk-devel
