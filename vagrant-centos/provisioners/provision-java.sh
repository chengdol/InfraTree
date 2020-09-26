#!/bin/bash
set -eux

## install required packages
sudo yum install -y java-1.8.0-openjdk-devel
java -version

## stop firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld
