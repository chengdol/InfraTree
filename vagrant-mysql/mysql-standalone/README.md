## Context
The purpose is to use Vagrant to deploy a **standalone** specified version MySQL 
community server on rocky Linux VM.

The MySQL community server GA release can be found and download from 
[here](https://dev.mysql.com/downloads/mysql/8.4.html).

Please choose the OS and version accordingly in terms of the Vagrant VM:
* **OS**: Red Hat Enterprise Linux / Oracle Linux
* **OS version**: Red Hat Enterprise Linux 9 / Oracle Linux 9 (ARM, 64-bit)

## Provision Script
The provision scripts are in `utils` folder, for example the version 8.0.42
script is named as `privision-mysql.sh`, then use it in the Vagrantfile.

If you want to try other MySQL community server versions, please create separate
provision script and use it in Vagrantfile.

## Vagrant Commands
Some basica Vagrant commands to bring up the server and SSH to it:
```bash
vagrant status

vagrant up

vagrant ssh

vagrant destroy -f
```

## Login
The root@localhost password is reset as `easyone`, please use it to login mysql.