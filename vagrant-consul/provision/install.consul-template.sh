#!/usr/bin/env bash

# Download consul-template
CONSUL_TEMPLATE_VERSION=0.25.0
URL=https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
curl $URL -o consul-template.zip

# Install consul-template
unzip consul-template.zip
sudo chmod +x consul-template
sudo mv consul-template /usr/bin/consul-template

## run in background
(consul-template -config /vagrant/provision/lb.consul-template.hcl >/dev/null 2>&1)&
