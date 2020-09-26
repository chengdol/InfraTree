## Prerequisite
For centos/redhat:
1. yum install ansible, ssh on master
2. yum install python 2.5+ and ssh on workers
3. setup passwordless ssh connections

## Description
This is an ansible quick setup, it contains basic directory structures to run ansible playbook.
After download, update the `inventory/inventory.sample` with your cluster machines.
```
[master]
example1.com

[workers]
example2.com
example3.com

[nodes]
example1.com
example2.com
example3.com
```

To run it:
```
./runAnsible.sh
```
Then you will see the hostname of each machine printed.
