#!/bin/bash
# Put provisioning stuff here

## generate ssh key pair
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
/bin/cp -f ~/.ssh/id_rsa.pub /vagrant/id_rsa.pub

## install jenkins and java openjdk
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins java-1.8.0-openjdk-devel

## start jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
## stop firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld

## if not disable firewalld, set below firewall configuration with sudo
#YOURPORT=8080
#PERM="--permanent"
#SERV="$PERM --service=jenkins"
#firewall-cmd $PERM --new-service=jenkins
#firewall-cmd $SERV --set-short="Jenkins ports"
#firewall-cmd $SERV --set-description="Jenkins port exceptions"
#firewall-cmd $SERV --add-port=$YOURPORT/tcp
#firewall-cmd $PERM --add-service=jenkins
#firewall-cmd --zone=public --add-service=http --permanent
#firewall-cmd --reload

