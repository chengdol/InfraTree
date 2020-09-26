#!/bin/bash
BASE_DIR=$(dirname `which $0`)
## set hostname with group
ANSIBLE_INVENTORY_FILE=${BASE_DIR}/inventory/inventory.sample
ANSIBLE_PLAYBOOK_DIR=${BASE_DIR}/playbooks
## set log path
sed -e "s|@PATH@|${ANSIBLE_PLAYBOOK_DIR}|" ${ANSIBLE_PLAYBOOK_DIR}/ansible.cfg.template > ${ANSIBLE_PLAYBOOK_DIR}/ansible.cfg
## run ansible playbook
cd ${ANSIBLE_PLAYBOOK_DIR}
ansible-playbook -v -i ${ANSIBLE_INVENTORY_FILE} initCluster.yml \
  -e "parameter1=hello" \
  -e "parameter2=world"
