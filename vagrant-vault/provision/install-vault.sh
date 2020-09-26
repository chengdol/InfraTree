#!/usr/bin/env bash
set -x

# Install unzip
sudo yum install -y unzip stress bc

cat >> ~/.bashrc <<"END"
# Coloring of hostname in prompt to keep track of what's what in demos, blue provides a little emphasis but not too much like red
NORMAL="\[\e[0m\]"
BOLD="\[\e[1m\]"
DARKGRAY="\[\e[90m\]"
BLUE="\[\e[34m\]"
PS1="$DARKGRAY\u@$BOLD$BLUE\h$DARKGRAY:\w\$ $NORMAL"
END

## install required packages
VAULT_VERSION="1.4.2"
wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
unzip vault_${VAULT_VERSION}_linux_amd64.zip
sudo chown root:root vault
sudo mv vault /usr/local/bin/

sudo systemctl stop firewalld
sudo systemctl disable firewalld
## setup softlink from shared folder if needed

## switch vagrant ssh login as root
#echo "sudo su -" >> /home/vagrant/.bashrc
