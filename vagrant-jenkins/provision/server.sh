#!/bin/bash
# Put provisioning stuff here

# generate ssh key pair
set -x
cd && ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
/bin/cp -f ~/.ssh/id_rsa.pub /vagrant/id_rsa.pub
set +x

# install jenkins and java openjdk
echo "Install Java..."
yum install -q -y java-1.8.0-openjdk-devel
echo "Install Jenkins..."
wget -q -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -q -y jenkins

# start jenkins
set -x
systemctl enable jenkins
systemctl start jenkins
# stop firewalld
systemctl stop firewalld
systemctl disable firewalld
set +x

# if not disable firewalld, set below firewall configuration with sudo
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

