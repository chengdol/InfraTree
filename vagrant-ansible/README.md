# Vagrant Ansible Setup

This repo is used for spinning up a single or multi-node ansible testing
environment via Vagrant.


1. Set up python3.8+ virtualenv locally on you control node
```bash
# managed virtualenv by virtualenvwrapper is also good 
virtualenv -p python3.8 ansible
# activate virtual environment
. ./ansible/bin/activate
```

2. Install ansible in virtualenv we just created
```bash
# upgrade pip if needed
pip install --upgrade pip

# install ansible v2.10+
# it will install ansible and ansible-base both
pip install ansible

# required by ansible if the connection
# method is paramiko
pip install paramiko
```

3. Make Vagrantfile and corresponding ansible inventory file

The `make.sh` is designed as idempotent, the output files it generated will override previous ones. 
```bash
# Default only create 1 VM, please see make usage.
./make.sh

# For example, make 3 VMs for Ansible management.
./make.sh 3
```

4. Launch ansible testing cluster
```bash
vagrant up
```

5. Run ad-hoc ansible command for availability check
```bash
ansible -v -i vagrant_ansible_inventory.ini all -m shell -a 'echo $(whoami)'
```
The output is something like:
```yaml
PLAY [Ansible Ad-Hoc] ********************************************************************************************************************************

TASK [shell] *****************************************************************************************************************************************
changed: [worker1] => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": true,
    "cmd": "echo $(whoami)",
    "delta": "0:00:00.004071",
    "end": "2021-03-28 01:55:41.056911",
    "rc": 0,
    "start": "2021-03-28 01:55:41.052840"
}

STDOUT:

root

PLAY RECAP *******************************************************************************************************************************************
worker1                    : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Happy to play, test with ad-hoc command or playbook!
```bash
# To test Ansible role, using the setup.yml as entry to call it.
ansible-playbook -i vagrant_ansible_inventory.ini setup.yml \
-e "version=1.23.45" \
-e "other_variable=foo"
```
As `ansible.cfg` specified, `ansible.log` is generated in the same folder.

6. Destroy cluster when you are done
```bash
vagrant destroy -f
```

7. Deactivate virtualenv
```
deactivate
```
