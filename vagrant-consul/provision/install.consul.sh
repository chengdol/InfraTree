#!/usr/bin/env bash
set -x

# Install unzip
sudo apt-get update
sudo apt-get install -y unzip stress bc

cat >> ~/.bashrc <<"END"

# Coloring of hostname in prompt to keep track of what's what in demos, blue provides a little emphasis but not too much like red
NORMAL="\[\e[0m\]"
BOLD="\[\e[1m\]"
DARKGRAY="\[\e[90m\]"
BLUE="\[\e[34m\]"
PS1="$DARKGRAY\u@$BOLD$BLUE\h$DARKGRAY:\w\$ $NORMAL"

END

# Download consul
CONSUL_VERSION=1.8.0
curl https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip

# Install consul
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul

## launch consul server and clients
## run subshell in background

## sometime it will fail, weird issue ,so loop check
while ! ps aux | grep -q "[c]onsul"
do
  HOST_NAME=$(hostname -f)
  ADVER_IP=$(ifconfig eth1 | grep 'inet addr' | awk '{ print substr($2,6) }')
  if [[ "$HOST_NAME" == "consul-server" ]]; then
    (consul agent -dev -bind 0.0.0.0 -advertise $ADVER_IP -client 0.0.0.0 >/dev/null 2>&1)&
  elif [[ "$HOST_NAME" == "ui" ]]; then
    (consul agent -config-file /vagrant/config/ui.consul.json -advertise $ADVER_IP >/dev/null 2>&1)&
  elif [[ "$HOST_NAME" == "lb" ]]; then
    ## actually these 2 config file can merge into one file
    (consul agent -config-file /vagrant/config/common.json -config-file /vagrant/config/lb.service.json -advertise $ADVER_IP >/dev/null 2>&1)&
  else ## web nodes
    (consul agent -config-file /vagrant/config/common.json -config-file /vagrant/config/web.service.json -advertise $ADVER_IP >/dev/null 2>&1)&
  fi
  sleep 10
done
