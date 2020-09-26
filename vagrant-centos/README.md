# Vagrant CentOS
This git repo contains Vagrantfile and provisioning shell script to set up a CentOS virtual machine locally through VirtualBox.
Check Vagrantfile and provisioning script to see more detail.

In `provisioners` folder, there are different provisioner shells to install different packages, sed required provisioner in Vagrantfile with other configurations. See below steps.

## Prerequisite
Download and install Vagrant:
- https://www.vagrantup.com/downloads

Download and install VirtualBox:
- https://www.virtualbox.org/wiki/Downloads

## Procedure
Create project folder:
```bash
mkdir vagrant-centos
cd vagrant-centos
git clone https://github.com/chengdol/vagrant-centos.git .
```

Check `provisioners` folder, using suffix to sed, for example, to setup basic environment:
```
sed -e "s|#SUFFIX#|basic|g" ./Vagrantfile-template > ./Vagrantfile
mkdir workspace
```

Simply run vagrant command to launch centOS virtual machine, the same command for boot machine after poweroff:
```bash
vagrant up
```

SSH to guest machine, vagrant user is in sudo group, switch to root user by `sudo su -`:
```bash
vagrant ssh
```

After exit from guest machine, poweroff, all changes in machine are kept:
```bash
vagrant halt
```

Or just delete and release all resources:
```bash
vagrant destroy -f
```

