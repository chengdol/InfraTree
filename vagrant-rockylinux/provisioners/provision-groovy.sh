#!/bin/bash
set -eux

#Install unzip if necessary
sudo yum install unzip -y
sudo yum install zip -y
## must have java before groovy
sudo yum install -y java-1.8.0-openjdk-devel
java -version

## install groovy by SDKMAN
curl -s get.sdkman.io | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install groovy
groovy -version

## stop firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld
