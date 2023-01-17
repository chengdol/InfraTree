# Docker Ansible Setup

For quick codelab in terms of Ansible syntax and features, we can set up docker
Ansible and run through localhost.

```bash
# Go to docker-ansible foler, build docker image for Ansible testing.
docker build -t ansible-test:latest -f ./ansible.dockerfile .

# In the same folder, mount "-v" any external Ansible playbooks or roles if
# necessary.
docker run -d \
--name ansible-test \
-w /root \
-v $(pwd)/setup.yml:/root/setup.yml \
-v $(pwd)/inventory.ini:/root/inventory.ini \
ansible-test:latest

# Launch shell from container.
docker exec -it ansible-test bash

# Test run ad-hoc ansible.
# local group is defined in inventory.ini
ansible -v -i inventory.ini local -m shell -a 'echo $(whoami)'

# Run for your mounted playbook/roles, for example.
ansible-playbook -i inventory.ini setup.yml \
-e "version=1.23.45" \
-e "other_variable=foo"

# Clean up
docker rm -f ansible-test
docker rmi -f ansible-test:latest
```
