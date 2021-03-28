# Vagrant Ansible Testing Cluster Setup

This repo is for bringing up a single or multiple nodes cluster for ansible testing purpose.


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
# default only create 1 VM
# please see make usage
./make.sh

# for example, make 3 VMs
./make.sh 3
```

4. Launch ansible testing cluster
```bash
vagrant up
```

5. Run ad-hoc ansible command for availability check
```bash
ansible -i vagrant_ansible_inventory.ini all -m shell -a 'echo $(whoami)'
```
The output is something like:
```
PLAY [Ansible Ad-Hoc] ********************************************************************************************************************************

TASK [shell] *****************************************************************************************************************************************
changed: [worker1]

PLAY RECAP *******************************************************************************************************************************************
worker1                    : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Happy to play, test with ad-hoc command or playbook!

As `ansible.cfg` specified, `ansible.log` is generated in the same folder.

6. Destroy cluster when you are done
```bash
vagrant destroy -f
```

7. Deactivate virtualenv
```
deactivate
```
